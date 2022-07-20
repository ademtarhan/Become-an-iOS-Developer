//
//  FirebaseService.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Combine
import FirebaseAuth
import Foundation

protocol FirebaseService {
    func deleteUser() -> Future<Bool, FirebaseError>
    func getUser(completion: @escaping (Result<FirebaseAuth.User?, FirebaseError>) -> Void)
    func createAccount(withEmail email: String, password: String, _ completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    var user: FirebaseAuth.User? { get }
}

class FirebaseServiceImpl: FirebaseService {
    var user: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func getUser(completion: @escaping (Result<User?, FirebaseError>) -> Void) {
        let User = Auth.auth().currentUser
        completion(.success(User))
    }

    func getUser(completion: @escaping (User, FirebaseError) -> Void) {
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

    func createAccount(withEmail email: String, password: String, _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(self.getAuthError(errCode: error._code)))
            } else {
                completion(.success(true))
            }
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
}
