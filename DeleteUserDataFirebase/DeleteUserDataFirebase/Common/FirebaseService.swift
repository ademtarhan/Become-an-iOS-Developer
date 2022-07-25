//
//  FirebaseService.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

protocol FirebaseService {
    func saveData(child: String, data: [String: String], completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func deleteUser() -> Future<Bool, FirebaseError>
    func getUser(completion: @escaping (Result<FirebaseAuth.User?, FirebaseError>) -> Void)
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    var user: FirebaseAuth.User? { get }
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
}

class FirebaseServiceImpl: FirebaseService {
    let FIRReference = Database.database().reference()

    func saveData(child: String, data: [String: String], completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let ref = FIRReference.child("\(child)").child("\(data["postid"]!)").setValue(data) { error, _ in
            if let error = error {
                completion(.failure(FirebaseError.timeOut))
            } else {
                completion(.success(true))
            }
        }
    }

    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(self.getAuthError(errCode: error._code)))
            } else {
                self.FIRReference.child("Users").setValue(data)

                completion(.success(true))
            }
        }
    }

    var user: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func getUser(completion: @escaping (Result<User?, FirebaseError>) -> Void) {
        let User = Auth.auth().currentUser
        completion(.success(User))
    }

    private func getAuthError(errCode: Int) -> FirebaseError {
        let error = AuthErrorCode(rawValue: errCode)
        switch error {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        default:
            return .unKnownError
        }
    }

    func deleteUser() -> Future<Bool, FirebaseError> {
        return Future { promise in
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    // An error happened.
                    print("account don't deleted")
                    promise(.failure(.timeOut))
                } else {
                    // Account deleted.
                    promise(.success(true))
                }
            }
        }
    }

    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        FIRReference.child("Posts").getData { error, snapShot in
            if let _ = error {
                completion(.failure(.unKnownError))
            } else {
                if snapShot.exists() {
                    guard let data = snapShot.value as? [String: Any] else {
                        return
                    }
                    for (id, d) in data {
                        guard let dict = d as? [String: Any] else {
                            return
                        }
                        let model = DataModel(snapShot: dict)
                        completion(.success(model))
                    }
                } else {
                    completion(.failure(.documentsError))
                }
            }
        }
    }

    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        FIRReference.child("Posts").child(postID).removeValue { error, _ in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(.timeOut))
            } else {
                completion(.success(true))
            }
        }
    }
}
