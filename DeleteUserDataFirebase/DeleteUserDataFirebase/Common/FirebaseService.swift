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
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void)

    //..MARK: firebase processes funcs
    func deleteAccount(with userID: String, completion: @escaping (Bool) -> Void)
    func deleteAquariums(with aquariumID: String, completion: @escaping (Bool) -> Void)
    func deleteDevices(with devicesID: String, completion: @escaping (Bool) -> Void)
}

class FirebaseServiceImpl: FirebaseService {
    let FIRReference = Database.database().reference()
    
    //..MARK: Firebase delete account and data processes
    
    //..MARK: Delete Account Func
    func deleteAccount(with userID: String, completion: @escaping (Bool) -> Void) {
        //..TODO: Delete Account
        FIRReference.child("Users").child(userID)
    }
    //..MARK: Delete Aquariums Func
    func deleteAquariums(with aquariumID: String, completion: @escaping (Bool) -> Void) {
        //..TODO: Delete Aquariums
    }
    //..MARK: Delete Devices Func
    
    func deleteDevices(with devicesID: String, completion: @escaping (Bool) -> Void) {
        //..TODO: Delete Devices
    }
    
    
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result,error in
            if let error = error {
                print("SigIn Error: \(error.localizedDescription)")
            }else{
                print("Log In Success")
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
        print(postID)
        let imageReference = Storage.storage().reference().child("images").child("\(postID)")
        let ref = Storage.storage().reference().child("images/\(postID)")
        print("----\(ref)")

        imageReference.downloadURL { url, error in
            if let err = error {
                print("Error--\(err.localizedDescription)")
            } else {
                let imageUrl = url?.absoluteString
                print("image url: \(imageUrl)")
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
        FIRReference.child("Posts").child(data.postID).setValue(data.asJson) { error, _ in
            if let _ = error {
                completion(.failure(FirebaseError.timeOut))
            } else {
                completion(.success(data))
            }
        }
    }

    // ..MARK: creat account function
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

    // ..MARK: delete data function
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
