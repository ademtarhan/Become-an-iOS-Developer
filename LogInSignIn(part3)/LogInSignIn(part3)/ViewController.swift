//
//  ViewController.swift
//  LogInSignIn(part3)
//
//  Created by Adem Tarhan on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageBackground: UIImageView!
    @IBOutlet var segmentControlLogSign: UISegmentedControl!

    @IBOutlet var buttonReqister: UIButton!

    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var textfieldPassword: UITextField!

    @IBOutlet var stackReqister: UIStackView!
    @IBOutlet var stackLog: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageBackground.blur(image: imageBackground)
        segmentControl()
    }

    //MARK: logn reqister screens control
    @IBAction func segmentControl() {
        if segmentControlLogSign.selectedSegmentIndex == 0 {
            buttonLogin.isHidden = true
            buttonReqister.isHidden = false
            stackReqister.isHidden = false
            stackLog.isHidden = true

        } else {
            textfieldPassword.isSecureTextEntry = true
            buttonLogin.isHidden = false
            buttonReqister.isHidden = true
            stackLog.isHidden = false
            stackReqister.isHidden = true
        }
    }

    //MARK: Show Password
    @IBAction func buttonShowpassword(_ sender: Int) {
        textfieldPassword.isSecureTextEntry = false
    }
}


//MARK: Extension - Blur effect for background image
extension UIImageView {
    func blur(image: UIImageView) {
        let inputImage = CIImage(cgImage: (image.image?.cgImage)!)

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(10, forKey: "inputRadius")
        let blurred = filter?.outputImage
        image.image = UIImage(ciImage: blurred!)
    }
}
