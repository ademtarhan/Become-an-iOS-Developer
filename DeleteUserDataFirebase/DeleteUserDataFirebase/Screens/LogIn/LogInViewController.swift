//
//  LogInViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import UIKit

protocol LogInViewController: AnyObject {
    func navToHome()
}

class LogInViewControllerImpl: UIViewController, LogInViewController {
    var presenter: LogInPresenter?
    
    
    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBOutlet weak var textfieldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = LogInPresenterImpl()
    }
    
    
    
    @IBAction func buttonCreate(_ sender: Any) {
        presenter?.createAccount(withEmail: textfieldEmail.text, password: textfieldPassword.text)
        self.navToHome()
    }
    
    
    
}

extension UIViewController {
    func navToHome() {
        DispatchQueue.main.async {
            let homeVC = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}