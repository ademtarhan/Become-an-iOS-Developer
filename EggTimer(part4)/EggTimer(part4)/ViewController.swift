//
//  ViewController.swift
//  EggTimer(part4)
//
//  Created by Adem Tarhan on 15.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonEgg1: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //buttonEgg1.layer.masksToBounds = true
        buttonEgg1.layer.cornerRadius = 20
        
    }


}

