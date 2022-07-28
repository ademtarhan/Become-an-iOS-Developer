//
//  HomePresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomePresenter: AnyObject {
    func getData()
    func deleteData(data: DataModel, postID: String)
    func saveItem(text: String?)
    func deleteAccount()
}

class HomePresenterImpl: HomePresenter {
    var interactor: HomeInteractor?

    var view: HomeViewControllerImpl?

    init(view: HomeViewControllerImpl) {
        interactor = HomeInteractorImpl()
        self.view = view
    }
    
    func deleteAccount() {
        interactor?.deleteAccount(completion: { bool in
            switch bool{
            case true:
                //self.view?.navToLog()  //..whose view is not in the window hierarchy.
                print("interactor bool is true")
            case false:
                break
            }
        })
    }
    
    
    // ..MARK: item text control
    func saveItem(text: String?) {
        if text == "" {
            print("text is empty")
        } else {
            interactor?.saveItem(text: text!, completion: { result in
                switch result {
                case let .success(post):
                    self.view?.appendData(data: post)
                case let .failure(error):
                    print(error)
                }
            })
        }
    }

   
    //..MARK: get data
    func getData() {
        interactor?.getData(completion: { result in
            switch result {
            case let .success(data):
                self.view?.appendData(data: data)
            case .failure:
                break
            }
        })
    }

    //..MARK: delete data
    func deleteData(data: DataModel, postID: String) {
        // ..
        interactor?.deleteData(with: data, postID: postID, completion: { result in
            switch result {
            case .success:
                
                print("success")
            case let .failure(error):
                print(error)
            }
        })
    }
}
