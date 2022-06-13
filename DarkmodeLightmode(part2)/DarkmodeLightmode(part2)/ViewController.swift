//
//  ViewController.swift
//  DarkmodeLightmode(part2)
//
//  Created by Adem Tarhan on 13.06.2022.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageMode: UIImageView!
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var labelMode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func buttonMode(_ sender: Any) {
        if switchMode.isOn {
            self.showAlert(title: "Dark Mode", message: "Dark mode switched")
            mainView.backgroundColor = .black
            labelTitle.textColor = .white
            imageMode.image = UIImage(named: "dark")
            labelMode.text = "Dark"
            labelMode.textColor = .white
            imageMode.layer.borderWidth = 3
            imageMode.layer.borderColor = UIColor.white.cgColor
        }else{
            self.showAlert(title: "Ligth Mode", message: "Ligth mode switched")
            mainView.backgroundColor = .white
            labelTitle.textColor = .black
            imageMode.image = UIImage(named: "light")
            labelMode.text = "Ligth"
            labelMode.textColor = .black
            imageMode.layer.borderWidth = 3
            imageMode.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}

extension UIViewController{
    
    func showAlert(title: String,message: String){
        let alert = UIAlertController(title: title,message:message,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

