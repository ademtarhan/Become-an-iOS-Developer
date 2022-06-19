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
    var second: Int = 0
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
        design(image: imageEgg)
    }

    // ..MARK: setup data function
    func setData() {
        second = setSecond()
        sliderTime.maximumValue = Float(second)
        minute = Int((value?[2])!)! / 60
        labelEggType.text = value?[0]
        imageEgg.image = UIImage(named: value?[1] ?? "egg-1")
        labelTime.text = "\(minute):\(second)"
    }

    // ..MARK: setup time function
    @objc func setTime() {
        second -= 1
        labelTime.text = "\(minute):\(second)"

        sliderTime.value = Float(second)
        print(sliderTime.value)
        if second == 0 && minute != 0 {
            minute -= 1
            second = 59
        }
        if minute == 0 && second == 0 {
            timer.invalidate()
            showAlert()
        }
    }

    // ..MARK: Action

    // ..MARK: play  function
    @IBAction func buttonPlay(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    }

    // ..MARK: pause  function
    @IBAction func buttonPause(_ sender: Any) {
        timer.invalidate()
    }

    // ..MARK: stop  function
    @IBAction func buttonStop(_ sender: Any) {
        timer.invalidate()
        second = setSecond()
        minute = Int((value?[2])!)! / 60
        labelTime.text = "\(minute):\(second)"
        sliderTime.value = Float(second)
    }

    // ..MARK: setup second function
    func setSecond() -> Int {
        if Int((value?[2])!)! % 60 == 0 {
            return 59
        } else {
            return Int((value?[2])!)! % 60
        }
    }
}

extension UIViewController {
    // ..MARK: for alert
    func showAlert() {
        let alert = UIAlertController(title: "Finished", message: "Eggs is cooked", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.navToHome()
        }))
        present(alert, animated: true, completion: nil)
    }

    // ..MARK: for back homeview
    func navToHome() {
        navigationController?.popViewController(animated: true)
    }

    // ..MARK: Design
    func design(image: UIImageView) {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
    }
}
