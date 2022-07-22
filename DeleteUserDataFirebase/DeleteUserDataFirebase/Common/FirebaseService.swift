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
    func fetchData(completion: @escaping (Result<String, FirebaseError>) -> Void)
    func retrieveData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    var user: FirebaseAuth.User? { get }
}

class FirebaseServiceImpl: FirebaseService {
    func saveData(child: String, data: [String: String], completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let ref = Database.database().reference().child("\(child)").childByAutoId().setValue(data) { error, _ in
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
                Database.database().reference().child("Users").setValue(data)

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

    func retrieveData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        let reference = Database.database().reference()

        reference.child("Users").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(FirebaseError.documentsError))
            } else {
                if snapshot.exists() {
                    snapshot.children.forEach { object in
                        guard let dict = object as? [String: Any], let name = dict["name"] as? String, let uid = dict["userid"] as? String else {
                            completion(.failure(.documentsError))
                            return
                        }
                        let model = DataModel(text: name, uid: uid)
                        print("FETCHED NAME \(model)")
//                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
//                    for userSnap in snapshot {
//                        guard let userData = userSnap.value as? Dictionary<String, AnyObject> else { return }
//
//                        let text = userData["text"] as? String ?? ""
//                        let uid = userData["userid"] as? String ?? ""
//                        var data = [String]()
//                        data.append(text)
//                        data.append(uid)
//                        completion(.success(data))
                    }
                }
            }
        }
    }

    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        let postRef = Database.database().reference()

        postRef.child("Posts").getData { error, snapShot in
            if let _ = error {
                completion(.failure(.unKnownError))
            } else {
                if snapShot.exists() {
                    print(snapShot.childrenCount)
                    snapShot.children.forEach { object in
                        print(object)
//                        guard let data = object as? [String:String],
//                              let text = data["text"] as? String,
//                              let uid = data["userid"] as? String
//                        else{
//                            completion(.failure(.documentsError))
//                            return
//                        }
//                        guard let dict = object as? [String: Any], let name = dict["name"] as? String, let uid = dict["userid"] as? String else {
//                            completion(.failure(.documentsError))
//                            return
//                        }
                        // let model = DataModel(text: text, uid: uid)
                        // print("FETCHED NAME \(model)")
                    }
                } else {
                    completion(.failure(.documentsError))
                }
            }
        }
        
    }

    func fetchData(completion: @escaping (Result<String, FirebaseError>) -> Void) {
        let reference = Database.database().reference().root.child("Posts")

        let database = Database.database()
        let ref = Database.database().reference()

        guard let id = Auth.auth().currentUser?.uid else {
            return print("Invalid UserID")
        }

        ref.child("User").child(id).observeSingleEvent(of: .value) { snapshot, _ in
            print(snapshot.value)

            // let text = (snapshot.value as! NSDictionary)["text"] as! String
        }

        reference.child(id).observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(FirebaseError.documentsError))
            } else {
                if snapshot.exists() {
                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                    for userSnap in snapshot {
                        guard let userData = userSnap.value as? Dictionary<String, AnyObject> else { return }
                        let text = userData["text"] as? String ?? ""
                        completion(.success(text))
                    }
                }
            }
        }
    }
}

/*
 reference.observe(DataEventType.value) { snapshot, error in
     if let error = error {
         print(error)
         completion(.failure(HomeError.invalidData))
     } else {
         print(snapshot)
         for data in snapshot.children.allObjects as! [DataSnapshot] {
             let object = data.value as! String
             let text = object
             let item = text
             completion(.success(item))
         }
     }
 }
  */
