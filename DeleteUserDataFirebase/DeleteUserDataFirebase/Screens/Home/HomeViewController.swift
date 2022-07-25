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

class HomeViewControllerImpl: UIViewController, HomeViewController {
    @IBOutlet var tableView: UITableView!

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

    func data() {
        let child = "Posts"
        guard let id = Auth.auth().currentUser?.uid else {return}
        guard let postID = Database.database().reference().childByAutoId().key else {return}

        let post = ["text": textfieldInput.text ?? "", "userid": id, "postid": postID]
        let post1 = DataModel(text: textfieldInput.text ?? "", uid: id, postid: postID)

        presenter?.saveData(with: child, wiht: post)
        //..presenter.savedata(data: post1)
    }

    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func buttonAddItem(_ sender: Any) {
        data()

        textfieldInput.text = ""
    }

    @IBAction func deleteAccount(_ sender: Any) {
        DispatchQueue.main.async {
            self.showAlert()
        }
    }

    func appendData(data: DataModel) {
        DispatchQueue.main.async {
            self.datas.append(data)
            self.tableView.reloadData()
        }
    }
}

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Deleted", message: "Account is deleted", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            self.navToLog()
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
            presenter?.deleteData(data: data, postID: data.postid)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}
