//
//  HomePresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomePresenter: AnyObject {
    
    func getData()
    func saveData(with child: String, wiht data: [String: String])
    func deleteData(data: DataModel,postID: String)
    func save(text: String?)
}

class HomePresenterImpl: HomePresenter {
    func save(text: String?) {
        //..TODO: text control
    }
    var interactor: HomeInteractor?

    var view: HomeViewControllerImpl?
    
    init(view: HomeViewControllerImpl) {
        interactor = HomeInteractorImpl()
        self.view = view
        //self.view = HomeViewControllerImpl()
    }

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

    func saveData(with child: String, wiht data: [String: String]) {
        interactor?.saveData(with: child, with: data, completion: { result in
            switch result {
            case .success:
                let dataModel = DataModel(text: data["text"]!, uid: data["userid"]!,postid: data["postid"]!)
                self.view?.appendData(data: dataModel)
            case .failure:
                break
            }
        })
    }
    
    func deleteData(data: DataModel,postID: String) {
       //..
        interactor?.deleteData(with: data, postID: postID, completion: { result in
            switch result{
            case let .success(true):
                print("success")
            case let .failure(error):
                print(error)
            case let .success(false):
                break
            }
        })
    }
}
