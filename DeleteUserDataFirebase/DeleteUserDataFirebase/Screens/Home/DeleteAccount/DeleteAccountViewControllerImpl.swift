//
//  DeleteAccountViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 28.07.2022.
//

import UIKit



protocol DeleteAccountViewController: AnyObject{
    
}



class DeleteAccountViewControllerImpl: UIViewController, DeleteAccountViewController {

    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBOutlet weak var textfieldPassword: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonLogIn(_ sender: Any) {
        
        
    }
    
    

}
