//
//  LogInPresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation

protocol LogInPresenter: AnyObject {
    var view: LogInViewController? { get set }
    func createAccount(withEmail email: String?, password: String?)
}

class LogInPresenterImpl: LogInPresenter {
    var view: LogInViewController?
    var interactor: LogInInteractorImpl?

    init() {
        view = LogInViewControllerImpl()
        interactor = LogInInteractorImpl()
    }

    func createAccount(withEmail email: String?, password: String?) {
        guard let email = email, let password = password else {
            // .. TODO: SHOW ERROR MESSAGE
            return
        }

        interactor?.createAccount(withEmail: email, password: password, { result in
            switch result {
            case .success:
                self.view?.navToHome()
            case .failure:
                break
            }
        })
    }
}
