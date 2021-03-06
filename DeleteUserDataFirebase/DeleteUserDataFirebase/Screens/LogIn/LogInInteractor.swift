//
//  LogInInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation
protocol LogInInteractor: AnyObject{
    func createAccount(withEmail email: String, password: String,data: [String:String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void)
}

class LogInInteractorImpl: LogInInteractor{
    var service: FirebaseService?
    
    init() {
        service = FirebaseServiceImpl()
    }
    
    
    func createAccount(withEmail email: String, password: String, data: [String:String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.createAccount(withEmail: email, password: password, data: data, { result in
            switch result{
            case .success(_):
                completion(.success(true))
            case .failure(_):
                completion(.failure(FirebaseError.timeOut))
            }
        })
    }
    
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void){
        service?.logIn(with: email, password: password, completion: { bool in
            switch bool{
            case true:
                completion(true)
            case false:
                completion(false)
            }
        })
    }
    
    
}
