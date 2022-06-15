//
//  HomeViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

class HomeViewController: UIViewController {

    //..MARK: Outlet
    
    @IBOutlet weak var buttonEgg1: UIButton!
    
    @IBOutlet weak var buttonEgg2: UIButton!
    
    @IBOutlet weak var buttonEgg3: UIButton!
    
    @IBOutlet weak var buttonEgg4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Egg Timer"
        // Do any additional setup after loading the view.
    }


    
    //..MARK: Action
    @IBAction func buttonShowTimer(_ sender: Any){
        let timerView = TimerViewController()
        navigationController?.pushViewController(timerView, animated: true)
    }
    
}
