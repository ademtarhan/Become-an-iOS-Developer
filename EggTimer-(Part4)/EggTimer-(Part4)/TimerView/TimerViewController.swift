//
//  TimerViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var labelEggType: UILabel!
    
    @IBOutlet weak var imageEgg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        print(Egg.eggType(type: Egg.EggType.easy)[0])
        // Do any additional setup after loading the view.
    }

    
    func setData() {
        labelEggType.text = Egg.eggType(type: Egg.EggType.hard)[0]
        imageEgg.image = UIImage(named: Egg.eggType(type: Egg.EggType.hard)[1])
    }
    
    

}
