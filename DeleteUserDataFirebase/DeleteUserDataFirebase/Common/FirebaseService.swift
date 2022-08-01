//
//  FirebaseService.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation
import UIKit

protocol FirebaseService {
    var user: FirebaseAuth.User? { get }
    var userid: String! { get }
    var postid: String! { get }
    func deleteUser() -> Future<Bool, FirebaseError>
    func getUser(completion: @escaping (Result<FirebaseAuth.User?, FirebaseError>) -> Void)
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func saveData(data: DataModel, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func saveImage(postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void)

    func downUrl(postID: String, completion: @escaping (Result<URL, FirebaseError>) -> Void)
    func logIn(with email: String, password: String, completion: @escaping (Bool) -> Void)

    // ..MARK: firebase processes funcs
    func deleteAccount(completion: @escaping (Result<Any, FirebaseError>) -> Void)
    func deleteAquariums(with aquariumID: String, completion: @escaping (Result<Any, FirebaseError>) -> Void)
    func deleteDevices(with deviceID: String, completion: @escaping (Result<Any, FirebaseError>) -> Void)
    func deleteAuth(completion: @escaping (Result<Any, FirebaseError>) -> Void)
}

class FirebaseServiceImpl: FirebaseService {
    let databaseRef = Database.database().reference()

    // ..MARK: Firebase delete account and data processes

    // ..MARK: Delete Account Func
    func deleteAccount(completion: @escaping (Result<Any, FirebaseError>) -> Void) {
        // ..TODO: Delete Account

        let currentUser = Auth.auth().currentUser
        guard let userID = currentUser?.uid else { return }
        // var aquariumsID = [String]()
        let userRef = databaseRef.child("Users").child(userID)

        let aquariumsRef = databaseRef.child("Users").child(userID).child("aquariums").ref
        let group = DispatchGroup()
        var stack = Stack()
        var aquariumsID = [String]()

        aquariumsRef.getData { error, data in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.timeOut))
            } else {
                if data.exists() {
                    guard let snap = data.value as? [String: Any] else { return }
                    for (id, _) in snap {
                        print("aquarium id:\(id)")
                        aquariumsID.append(id)
                        stack.push(id)

                        /*
                           self.deleteAquariums(with: id) { result in
                              switch result {
                              case .success:
                                  // ..MARK: deleted aquarium

                                  self.removeData(ref: userRef) { result in
                                      switch result {
                                      case .success:
                                          self.deleteAuth { result in
                                              switch result{
                                              case .success:
                                                  completion(.success(true))
                                              case .failure:
                                                  completion(.failure(.deleteAccountError))
                                              }
                                          }
                                      case .failure:
                                          completion(.failure(.deleteAccountError))
                                      }
                                  }
                              case .failure:
                                  // ..MARK: not deleted aquarium
                                  completion(.failure(.deleteAquariumError))
                              }
                          }
                         */
                    }
                    print(stack.pop())
                    self.deleteAquariums(with: stack.pop()) { result in
                        switch result {
                        case .success:
                            print("success-deleted \(stack.pop())")
                            completion(.success(true))
                        case .failure:
                            completion(.failure(.deleteAquariumError))
                        }
                    }
                }
            }
        }
    }

    // ..MARK: Delete Aquariums Func
    func deleteAquariums(with aquariumID: String, completion: @escaping (Result<Any, FirebaseError>) -> Void) {
        // ..TODO: Delete Aquariums

        var devicesID = [String]()
        let aquariumsRef = databaseRef.child("aquariums").child(aquariumID)
        let deviceRef = databaseRef.child("aquariums").child(aquariumID).child("devices").ref
        let group = DispatchGroup()

        deviceRef.getData { error, data in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(data)
                if data.exists() {
                    guard let snap = data.value as? [String: Any] else { return }
                    for (id, _) in snap {
                        print("device id :\(id)")
                        devicesID.append(id)

                        self.deleteDevices(with: id) { result in
                            switch result {
                            case .success:
                                // ..MARK: deleted device
                                self.removeData(ref: aquariumsRef) { result in
                                    switch result {
                                    case .success:
                                        completion(.success(true))
                                    case .failure:
                                        completion(.failure(.deleteAquariumError))
                                    }
                                }

                            case .failure:
                                // ..MARK: not deleted device
                                completion(.failure(.deleteDeviceError))
                            }
                        }
                    }
                }else{
                    print("not exists")
                }
            }
        }
    }

    // ..MARK: Deleted Devices Func

    func deleteDevices(with devicesID: String, completion: @escaping (Result<Any, FirebaseError>) -> Void) {
        // ..TODO: Delete Devices

        let deviceRef = databaseRef.child("devices").child(devicesID).ref

        removeData(ref: deviceRef) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.deleteDeviceError))
            }
        }
    }

    func deleteAuth(completion: @escaping (Result<Any, FirebaseError>) -> Void) {
        Auth.auth().currentUser?.delete(completion: { error in
            if let err = error {
                // ..MARK: not deleted auth
                print(err.localizedDescription)
                completion(.failure(.timeOut))
            } else {
                // ..MARK: deleted auth
                completion(.success(true))
//                self.deleteAccount { result in
//                    switch result {
//                    case .success:
//                        completion(.success(true))
//                    case .failure:
//                        completion(.failure(.deleteAccountError))
//                    }
//                }
            }
        })
    }

    func logIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("SigIn Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Log In Success")
                completion(true)
            }
        }
    }

    var userid: String! {
        Auth.auth().currentUser?.uid ?? ""
    }

    var postid: String! {
        Database.database().reference().childByAutoId().key ?? ""
    }

    var user: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func downUrl(postID: String, completion: @escaping (Result<URL, FirebaseError>) -> Void) {
        let imageReference = Storage.storage().reference().child("images").child("\(postID)")
        _ = Storage.storage().reference().child("images/\(postID)")

        imageReference.downloadURL { url, error in
            if let err = error {
                print("Error--\(err.localizedDescription)")
            } else {
                _ = url?.absoluteString
                completion(.success(url!))
            }
        }
    }

    func saveImage(postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageFolder = storageReference.child("images")

        // ..child("\(postid).jpg")
        if let data = postImage.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = imageFolder.child("\(postid ?? "")")

            imageReference.putData(data, metadata: nil) { _, error in
                if let _ = error {
                    completion(.failure(.uploadError))
                } else {
                    // ..TODO: download post datas
                    completion(.success(true))
                }
            }
        }
    }

    // ..MARK: save data with DataModel
    func saveData(data: DataModel, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        databaseRef.child("Posts").child(data.postID).setValue(data.asJson) { error, _ in
            if let _ = error {
                completion(.failure(FirebaseError.timeOut))
            } else {
                completion(.success(data))
            }
        }
    }

    // ..MARK: creat account function
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        guard let currenUserID = Auth.auth().currentUser?.uid else { return }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in

            if let error = error {
                completion(.failure(self.getAuthError(errCode: error._code)))
            } else {
                self.databaseRef.child("Users").child("\(currenUserID)").setValue(data)

                completion(.success(true))
            }
        }
    }

    // ..MARK: get user function
    func getUser(completion: @escaping (Result<User?, FirebaseError>) -> Void) {
        let User = Auth.auth().currentUser
        completion(.success(User))
    }

    // ..MARK: get Auth error type function
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

    // ..MARK: delete user function
    func deleteUser() -> Future<Bool, FirebaseError> {
        return Future { promise in
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let _ = error {
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

    // ..MARK: get data function
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        databaseRef.child("Posts").getData { error, snapShot in
            if let _ = error {
                completion(.failure(.unKnownError))
            } else {
                if snapShot.exists() {
                    guard let data = snapShot.value as? [String: Any] else {
                        return
                    }
                    for (_, d) in data {
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

    // ..MARK: delete data function
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let ref = databaseRef.child("Posts").child(postID)
        removeData(ref: ref) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.removeValueError))
            }
        }
    }

    func removeData(ref: DatabaseReference, completion: @escaping (Result<Any, Error>) -> Void) {
        ref.removeValue { error, _ in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
            } else {
                completion(.success(true))
            }
        }
    }
}
