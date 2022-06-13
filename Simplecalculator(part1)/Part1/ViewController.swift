//
//  ViewController.swift
//  Part1
//
//  Created by Adem Tarhan on 12.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textFirstNumber: UITextField!
    @IBOutlet weak var textSecondNumber: UITextField!
    
    @IBOutlet weak var labelResult: UILabel!
    
    var buttons : [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    @IBAction func buttonAddition(_ sender: Any) {
        
        let result = converter(text: textFirstNumber.text!) + converter(text: textSecondNumber.text!)
        
        labelResult.text = String(result)
    }
    
    @IBAction func buttonSubtraction(_ sender: Any) {
        let result = converter(text: textFirstNumber.text!) - converter(text: textSecondNumber.text!)
        labelResult.text = String(result)
    }
    
    @IBAction func buttonDivision(_ sender: Any) {
        let result = converter(text: textFirstNumber.text!) / converter(text: textSecondNumber.text!)
        labelResult.text = String(result)
    }
    
    @IBAction func buttonMultiplication(_ sender: Any) {
        let result = converter(text: textFirstNumber.text!) * converter(text: textSecondNumber.text!)
        labelResult.text = String(result)
    }
    
    
    func converter(text:String) -> Int{
        
        let number = Int(text) ?? 0
        print(number)
        return number
    }
    
    
}

