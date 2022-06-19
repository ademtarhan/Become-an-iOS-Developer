//
//  ViewController.swift
//  Navigation
//
//  Created by Adem Tarhan on 18.06.2022.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //..MARK: Navigation
    
    
    @IBAction func buttonNavToSecondScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondCV = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        secondCV.modalPresentationStyle = .fullScreen
        self.present(secondCV, animated: true, completion: nil)
    }
    
    

}

