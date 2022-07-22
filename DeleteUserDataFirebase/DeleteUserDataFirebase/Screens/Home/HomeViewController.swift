//
//  HomeViewController.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import FirebaseDatabase
import UIKit
import FirebaseAuth

protocol HomeViewController: AnyObject {
    var dataCount: Int? { get set }
    var presenter: HomePresenter? { get set }
    var datas: [String] { get set }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
}

class HomeViewControllerImpl: UIViewController, HomeViewController {
    @IBOutlet var tableView: UITableView!

    @IBOutlet var textfieldInput: UITextField!
    var datas = [String]()
    var presenter: HomePresenter?
    var dataCount: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        

        let nibCell = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")

        presenter = HomePresenterImpl()
        
        print(Auth.auth().currentUser?.uid)
        //presenter?.fetchData()
        presenter?.getData()
        //presenter?.retrieveData()
        print(datas.count)
        tableView.delegate = self
        tableView.dataSource = self
    }
    func data() {
        let child = "Posts"
        let id = Auth.auth().currentUser?.uid ?? ""
        let post = ["text": textfieldInput.text ?? "","userid": id]
        presenter?.saveData(with: child, wiht: post)
    }

    @IBAction func buttonAddItem(_ sender: Any) {
        data()
    }

    @IBAction func deleteAccount(_ sender: Any) {
        DispatchQueue.main.async {
            self.showAlert()
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
        print("asadfg\(datas.count)")
        return datas.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let item = datas[indexPath.row]
        print(item)
        cell.labelCellText.text = item
        cell.labelUID.text = item
        return cell
    }
}
