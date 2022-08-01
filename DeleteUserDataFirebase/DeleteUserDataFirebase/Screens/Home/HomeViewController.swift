//
//  HomeViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos
import UIKit

protocol HomeViewController: AnyObject {
    var dataCount: Int? { get set }
    var presenter: HomePresenter? { get set }
    func appendData(data: DataModel)
}

class HomeViewControllerImpl: UIViewController, HomeViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!

    var datas = [DataModel]()
    var presenter: HomePresenter?
    var dataCount: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "DEMO"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(goToAdd))

        let nibCell = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        presenter = HomePresenterImpl(view: self)
        presenter?.getData()
    }

    @objc func goToAdd() {
        let AddVC = AddViewControllerImpl(nibName: "AddViewController", bundle: nil)

        navigationController?.pushViewController(AddVC, animated: true)
    }

    // ..MARK: delete account button
    @IBAction func deleteAccount(_ sender: Any) {
        DispatchQueue.main.async {
            self.showDeleteAccountAlert()
        }
        
    }

    // ..MARK: append data and reload table view
    func appendData(data: DataModel) {
        DispatchQueue.main.async {
            self.datas.append(data)
            self.tableView.reloadData()
        }
    }

    func uploadImage() {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("images")
        let imageReference = mediaFolder.child("photo.jpg")
    }
}

extension HomeViewControllerImpl {
    func showAddItemAlert() {
        var postText: String = ""
        let alert = UIAlertController(title: "Share Post", message: "", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Add Image", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true)
        }))

        alert.addTextField { field in
            field.placeholder = "Post Text"
            postText = field.text ?? ""
        }
        alert.addAction(UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: { _ in
            self.presenter?.saveItem(text: postText)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { [self] _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.presenter?.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showtimer() {
        let alert = UIAlertController(title: "timer finished", message: "timer finished", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.navToLog()
        }))
        present(alert, animated: true, completion: nil)
        
    }

    func navToLog() {
        let logInVC = LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
        logInVC.modalPresentationStyle = .fullScreen
        logInVC.modalTransitionStyle = .crossDissolve
        present(logInVC, animated: true, completion: nil)
    }
}

extension HomeViewControllerImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = datas[indexPath.row]
        print(item)
        cell.setdata(data: item)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let data = datas.remove(at: indexPath.row)
            presenter?.deleteData(data: data, postID: data.postID)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension HomeViewControllerImpl {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            let filePath = "Images/photo.jpg"
        }
    }
}
