//
//  HomeViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

protocol HomeImplementable: AnyObject {
    var val: String? {get set}
}

class HomeViewController: UIViewController, HomeImplementable {
   
    // ..MARK: Outlet

    @IBOutlet var buttonEgg1: UIButton!

    @IBOutlet var buttonEgg2: UIButton!

    @IBOutlet var buttonEgg3: UIButton!

    @IBOutlet var buttonEgg4: UIButton!

    public var val: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Egg Timer"
        print("---")
        func navigateToTimer() {
            val = "---ds--"
            var destination: TimerImplementable = TimerViewController() as! TimerImplementable
            destination.value = self

            guard let destinationViewController = destination as? UIViewController else { return }
            present(destinationViewController, animated: true)
        }

        // Do any additional setup after loading the view.
    }

    

    // ..MARK: Action
    @IBAction func buttonShowTimer(_ sender: UIButton) {
        let timerView = TimerViewController()
        navigationController?.pushViewController(timerView, animated: true)

        switch sender {
        case buttonEgg1:
            Egg.eggType(type: .easy)
            val = Egg.eggType(type: .easy)[0]
        case buttonEgg2:
            Egg.eggType(type: .medium)
            val = "Medium"
        case buttonEgg3:
            Egg.eggType(type: .hard)
            val = "Hard"
        case buttonEgg4:
            Egg.eggType(type: .so_hard)
            val = "Hard_So"
        default:
            break
        }
    }
}
