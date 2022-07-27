//
//  HomeViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

protocol HomeViewController: AnyObject {
    var dataCount: Int? { get set }
    var presenter: HomePresenter? { get set }
    func appendData(data: DataModel)
}

class HomeViewControllerImpl: UIViewController, HomeViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textfieldInput: UITextField!

    var datas = [DataModel]()
    var presenter: HomePresenter?
    var dataCount: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        presenter = HomePresenterImpl(view: self)
        presenter?.getData()
    }

    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Context", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something interesting with "answer" here
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }


    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        dismiss(animated: true, completion: { () -> Void in

        })

        imageView.image = image
    }

    // ..MARK: add Item button
    @IBAction func buttonAddItem(_ sender: Any) {
        var imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }

        // showAddItemAlert()
        presenter?.saveItem(text: textfieldInput.text) // ..MARK: for data model - HomeEntity
        textfieldInput.text = ""
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
}

extension UIViewController {
    func showAddItemAlert() {
        let alert = UIAlertController(title: "Share Post", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { field in
            field.placeholder = "Post Text"
        }
        alert.addAction(UIAlertAction(title: "Add Image", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { [self] _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "Deleted", message: "Account is deleted", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.navToLog()
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

    func showEmptyTextAlert() {
        let alert = UIAlertController(title: "Empty Space", message: "Please fill in the blank", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showDeletedItemAlert() {
        let alert = UIAlertController(title: "Deleted", message: "Post is deleted", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func navToLog() {
        let logInVC = LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
        logInVC.modalPresentationStyle = .fullScreen
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
