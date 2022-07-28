//
//  LogInPresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation

protocol LogInPresenter: AnyObject {
    var view: LogInViewController? { get set }
    func createAccount(withEmail email: String?, password: String?,data: [String:String])
    func logIn(with email: String,password: String) -> Void
}

class LogInPresenterImpl: LogInPresenter {
    var view: LogInViewController?
    var interactor: LogInInteractorImpl?

    init() {
        view = LogInViewControllerImpl()
        interactor = LogInInteractorImpl()
    }
    
    func logIn(with email: String,password: String) -> Void{
        interactor?.signIn(with: email, password: password, completion: { bool in
            switch bool {
            case true:
                break
            case false:
                break
            }
        })
    }

    
    
    func createAccount(withEmail email: String?, password: String?,data: [String:String]) {
        guard let email = email, let password = password else {
            // .. TODO: SHOW ERROR MESSAGE
            return
        }

        interactor?.createAccount(withEmail: email, password: password, data: data, { result in
            switch result {
            case .success:
                self.view?.navToHome()
            case .failure:
                break
            }
        })
    }
}
