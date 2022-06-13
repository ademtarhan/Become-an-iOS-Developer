//
//  ViewController.swift
//  LogInSignIn(part3)
//
//  Created by Adem Tarhan on 13.06.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageBackground: UIImageView!
    @IBOutlet weak var segmentControlLogSign: UISegmentedControl!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    
    @IBOutlet weak var buttonReqisterLogin: UIButton!
    private enum PageType {
        case reqister
        case login
    }
    private var currentPageType : PageType = .login {
        didSet{
            print("\(currentPageType)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blur(image: imageBackground)
    }
    
    private func setupViews(pagetype: PageType){
        textfieldPassword.isHidden = pagetype == .login
       
        
    }
    
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl){
        currentPageType = sender.selectedSegmentIndex == 0 ? .login : .reqister
    }
    

   
    func blur(image: UIImageView) {
        let inputImage = CIImage(cgImage: (image.image?.cgImage)!)

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(10, forKey: "inputRadius")
        let blurred = filter?.outputImage
        image.image = UIImage(ciImage: blurred!)
    }
}

