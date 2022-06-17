//
//  TimerViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

protocol TimerImplementable: AnyObject {
    var value: [String]? { get set }
}

class TimerViewController: UIViewController, TimerImplementable {
    var value: [String]?
    
    
    var second : Int = 0
    
    var minute: Int = 0
    
    var timer = Timer()

    // ..MARK: Outlet
    @IBOutlet var labelEggType: UILabel!

    @IBOutlet var imageEgg: UIImageView!

    @IBOutlet var labelTime: UILabel!

    @IBOutlet var sliderTime: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()

    }

    func setData() {
        second = setSecond()
        minute = Int((value?[2])!)! / 60
        labelEggType.text = value?[0]
        imageEgg.image = UIImage(named: value?[1] ?? "egg-1")
        labelTime.text = "\(minute):\(second)"
    }

    @objc func setTime() {
        second -= 1
        labelTime.text = "\(minute):\(second)"
        sliderTime.maximumValue = Float(minute*60+second)
        sliderTime.value = Float(1)
        print(sliderTime.value)
        print(sliderTime.maximumValue)
        if second == 0 && minute != 0 {
            minute -= 1
            second = 59
        }
        if minute == 0 && second == 0{
            timer.invalidate()
            showAlert()
        }
    }

    // ..MARK: Action

    @IBAction func buttonPlay(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    }

    @IBAction func buttonPause(_ sender: Any) {
        timer.invalidate()
    }

    @IBAction func buttonStop(_ sender: Any){
        timer.invalidate()
        second = setSecond()
        minute = Int((value?[2])!)! / 60
        labelTime.text = "\(minute):\(second)"
        sliderTime.value = Float(second)
    }
    
    func setSecond() -> Int{
        if Int((value?[2])!)! % 60 == 0 {
            return 59
        }else{
            return Int((value?[2])!)! % 60
        }
    }
}

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Finished", message: "Eggs is cooked", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert,animated: true, completion: nil)
    }
}
