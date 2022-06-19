//
//  SecondViewController.swift
//  Navigation
//
//  Created by Adem Tarhan on 18.06.2022.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    @IBAction func buttonNavToFirstScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstCV = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        firstCV.modalPresentationStyle = .fullScreen
        self.present(firstCV, animated: true, completion: nil)
    }
    

}
