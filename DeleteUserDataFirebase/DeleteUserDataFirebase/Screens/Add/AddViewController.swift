//
//  AddViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 27.07.2022.
//

import UIKit

protocol AddViewController: AnyObject {
    func updateUI(message: String)
}

class AddViewControllerImpl: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddViewController {
    @IBOutlet var imagePost: UIImageView!
    @IBOutlet var textPost: UITextView!
    let imagePicker = UIImagePickerController()
    var presenter: AddPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Share Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Image", style: .plain, target: self, action: #selector(addImage))

        presenter = AddPresenterImpl(view: self)
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    @objc func addImage() {
        showChooeseImageType()
    }

    @IBAction func buttonSharePost(_ sender: Any) {
        presenter?.saveImage(postImage: imagePost, postText: textPost.text)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) // ..MARK: changed
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePost.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
}

extension AddViewControllerImpl {
    func navigationToHome() {
        navigationController?.popViewController(animated: true)
    }

    func showChooeseImageType() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func showEmptyTextAlert() {
        let alert = UIAlertController(title: "Empty Space", message: "Please fill in the blank", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    

    func updateUI(message: String) {
        DispatchQueue.main.async {
            // TODO: SHOW DIALOG
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
