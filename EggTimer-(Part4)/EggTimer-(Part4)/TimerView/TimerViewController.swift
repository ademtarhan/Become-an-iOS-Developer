//
//  TimerViewController.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

protocol TimerImplementable : AnyObject{
    var value : HomeImplementable? {get set}
}

class TimerViewController: UIViewController , TimerImplementable {
    var second : Int = 0
    var minute : Int = 0
    var timer = Timer()
    var value: HomeImplementable?
    
    
    
    //..MARK: Outlet
    @IBOutlet var labelEggType: UILabel!

    @IBOutlet var imageEgg: UIImageView!

    @IBOutlet var labelTime: UILabel!

    @IBOutlet var sliderTime: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        print(value?.val)
        
    }

    func setData() {
        //var minute = Int(Egg.eggType(type: .medium)[2])
        //var second = Int(Egg.eggType(type: .medium)[2])
        labelEggType.text = Egg.eggType(type: .medium)[0]
        imageEgg.image = UIImage(named:  Egg.eggType(type: .medium)[1])
        labelTime.text = Egg.eggType(type: .medium)[2]
    }

    @objc func setTime() {
        second -= 1
        labelTime.text = "\(minute):\(second)"
        sliderTime.value = Float(second)
        if second == 0 {
            minute -= 1
            second = 59
        }
        
    }

    // ..MARK: Action

    @IBAction func buttonPlay(_ sender: Any) {
        print("55")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTime), userInfo: nil, repeats: true)
    }

    @IBAction func buttonPause(_ sender: Any) {
        timer.invalidate()
    }

    @IBAction func buttonStop(_ sender: Any) {
        timer.invalidate()
        second = 59
        minute = 4
        labelTime.text = "\(minute):\(second)"
        sliderTime.value = Float(second)
        
    }
}
