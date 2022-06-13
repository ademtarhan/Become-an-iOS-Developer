//
//  ViewController.swift
//  DarkmodeLightmode(part2)
//
//  Created by Adem Tarhan on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageMode: UIImageView!
    
    @IBOutlet weak var switchMode: UISwitch!
    
    
    @IBOutlet weak var labelMode: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---\(switchMode)")
    }

    
    @IBAction func buttonSwitch(_ sender: Any) {
    }
    
    

}

