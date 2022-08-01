//
//  LogInViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import UIKit

protocol LogInViewController: AnyObject {
    func navigateToHome()
}

class LogInViewControllerImpl: UIViewController, LogInViewController {
    var presenter: LogInPresenter?

    @IBOutlet var emailTextField: UITextField!

    @IBOutlet var textfieldPassword: UITextField! // TODO: Rename
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = LogInPresenterImpl()
    }

    @IBAction func didTapLogIn(_ sender: Any) {
        presenter?.logIn(with: emailTextField.text ?? "", password: textfieldPassword.text ?? "")
        navigateToHome()
    }

    @IBAction func didTapCreate(_ sender: Any) {
        let data = ["Email": emailTextField.text ?? "", "Password": textfieldPassword.text ?? ""]

        presenter?.createAccount(withEmail: emailTextField.text, password: textfieldPassword.text, data: data)
    }
}

// MARK: Navigation
extension UIViewController {
    func navigateToHome() {
        DispatchQueue.main.async {
            let homeVC = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}
