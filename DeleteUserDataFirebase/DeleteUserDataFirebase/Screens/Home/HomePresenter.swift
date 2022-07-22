//
//  HomePresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomePresenter: AnyObject {
    var view: HomeViewController? { get set }
    var datacount: Int? { get }
    var datas: [DataModel] { get set }
    func dataCount() -> Int
    func fetchData()
    func getData()
    func retrieveData()
    func saveData(with child: String, wiht data: [String: String])
}

class HomePresenterImpl: HomePresenter {
    
    var datas = [DataModel]()
    

    var interactor: HomeInteractor?
    var datacount: Int? {
        datas.count
    }

    init() {
        interactor = HomeInteractorImpl()
    }

    var view: HomeViewController?

    func dataCount() -> Int {
        return 10
    }

    func fetchData() {
        print(datas)
        interactor?.fetchData(completion: { result in
            switch result {
            case let .success(item):
                //self.datas.append(item)
                self.view?.datas.append(item)
                print(self.datas.count)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func retrieveData(){
        interactor?.retrieveData(completion: { result in
            switch result {
            case let .success(data):
                self.datas.append(data)
                print(data)
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func getData() {
        interactor?.getData(completion: { result in
            switch result {
            case let .success(data):
                self.datas.append(data)
                print(data)
            case .failure:
                break
            }
        })
    }
    

    func saveData(with child: String, wiht data: [String: String]) {
        interactor?.saveData(with: child, with: data, completion: { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        })
    }
}
