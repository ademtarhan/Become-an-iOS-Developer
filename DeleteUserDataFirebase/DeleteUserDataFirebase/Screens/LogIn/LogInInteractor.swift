//
//  LogInInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation
protocol LogInInteractor: AnyObject{
    func createAccount(withEmail email: String, password: String, _ completion: @escaping (Result<Bool, FirebaseError>) -> Void)
}

class LogInInteractorImpl: LogInInteractor{
    var service: FirebaseService?
    
    init() {
        service = FirebaseServiceImpl()
    }
    
    
    func createAccount(withEmail email: String, password: String, _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.createAccount(withEmail: email, password: password, { error in
            guard error != nil else{
                return
            }
        })
    }
    
    
    
}
