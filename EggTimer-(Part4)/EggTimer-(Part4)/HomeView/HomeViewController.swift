//
//  HomeViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

protocol HomeImplementable: AnyObject {
    var val: [String]? { get set }
}

class HomeViewController: UIViewController, HomeImplementable {
    var val: [String]?
    
    // ..MARK: Outlet

    @IBOutlet var buttonEgg1: UIButton!

    @IBOutlet var buttonEgg2: UIButton!

    @IBOutlet var buttonEgg3: UIButton!

    @IBOutlet var buttonEgg4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Egg Timer"
        print("---")

        // Do any additional setup after loading the view.
    }

    // ..MARK: Action
    @IBAction func buttonShowTimer(_ sender: UIButton) {
        let destination = TimerViewController()
        
        
        

        
        
        switch sender {
        case buttonEgg1:
            destination.value = Egg.eggType(type: .easy)
        case buttonEgg2:
            destination.value = Egg.eggType(type: .medium)
        case buttonEgg3:
            destination.value = Egg.eggType(type: .hard)
        case buttonEgg4:
            destination.value = Egg.eggType(type: .so_hard)
        default:
            break
        }
        navigationController?.pushViewController(destination, animated: true)
    }
}
