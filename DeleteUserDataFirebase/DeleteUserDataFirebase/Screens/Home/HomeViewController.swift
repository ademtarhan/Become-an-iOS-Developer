//
//  HomeViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import UIKit

protocol HomeViewController: AnyObject{
    
}

class HomeViewControllerImpl: UIViewController,HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Demo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete Account", style: .plain, target: self, action: #selector(deleteAccount))
    }

    @objc func deleteAccount() {
        DispatchQueue.main.async {
            self.showAlert()
        }
    }

    
}

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Deleted", message: "Account is deleted", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.navToLog()
        }))
        present(alert, animated: true, completion: nil)
    }

    func navToLog() {
        let logInVC = LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
        logInVC.modalPresentationStyle = .fullScreen
        present(logInVC, animated: true, completion: nil)
    }
}
