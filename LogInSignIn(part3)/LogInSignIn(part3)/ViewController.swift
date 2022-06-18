//
//  ViewController.swift
//  LogInSignIn(part3)
//
//  Created by Adem Tarhan on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {
    // ..MARK: Outlet
    @IBOutlet var imageBackground: UIImageView!
    @IBOutlet var segmentControlLogSign: UISegmentedControl!
    @IBOutlet var buttonRegister: UIButton!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var textfieldPassword: UITextField!
    @IBOutlet var stackReqister: UIStackView!
    @IBOutlet var stackLog: UIStackView!
    @IBOutlet var textfiledUserNameForLogin: UITextField!
    @IBOutlet var textfieldPasswordForLogin: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageBackground.blur(image: imageBackground)
        segmentControl()
    }

    // MARK: logn reqister screens control

    @IBAction func segmentControl() {
        if segmentControlLogSign.selectedSegmentIndex == 0 {
            buttonLogin.isHidden = true
            buttonRegister.isHidden = false
            stackReqister.isHidden = false
            stackLog.isHidden = true

        } else {
            textfieldPassword.isSecureTextEntry = true
            buttonLogin.isHidden = false
            buttonRegister.isHidden = true
            stackLog.isHidden = false
            stackReqister.isHidden = true
        }
    }

    // MARK: Show Password

    @IBAction func buttonShowpassword(_ sender: Int) {
        textfieldPassword.isSecureTextEntry = false
    }

    func navToTabBar() {
        print(51)
        
        let destination = TabbarViewController() as! TabbarViewController;()
        navigationController?.pushViewController(destination, animated: true)
    }

    // ..MARK: Action

    @IBAction func buttonLogin(_ sender: Any) {
        print(59)
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        print(destination)
        navigationController?.pushViewController(destination, animated: true)
//        if textfiledUserNameForLogin.text == "adem" && textfieldPasswordForLogin.text == "12345" {
//            navToTabBar()
//        }else{
//            showAlert()
//        }
    }

    @IBAction func buttonRegister(_ sender: Any) {
    }
}

// MARK: Extension - Blur effect for background image

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

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
