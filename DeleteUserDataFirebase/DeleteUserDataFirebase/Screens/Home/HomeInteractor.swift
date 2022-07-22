//
//  HomeInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomeInteractor: AnyObject {
    func fetchData(completion: @escaping (Result<String, HomeError>) -> Void)
    func saveData(with child: String, with data: [String:String], completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func retrieveData(completion: @escaping (Result<DataModel,FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel,FirebaseError>) -> Void)
}

class HomeInteractorImpl: HomeInteractor {
    func saveData(with child: String, with data: [String:String], completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.saveData(child: child, data: data, completion: { result in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    var service: FirebaseService?

    init() {
        service = FirebaseServiceImpl()
    }

    func fetchData(completion: @escaping (Result<String, HomeError>) -> Void) {
        service?.fetchData(completion: { result in
            switch result {
            case let .success(item):
                completion(.success(item))
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func retrieveData(completion: @escaping (Result<DataModel,FirebaseError>) -> Void){
        service?.retrieveData(completion: { result in
            switch result{
            case let .success(datas):
                completion(.success(datas))
            case let .failure(error):
                completion(.failure(error))
            }
        })
        
    }
    
    
    func getData(completion: @escaping (Result<DataModel,FirebaseError>) -> Void){
        service?.getData(completion: { result in
            switch result{
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
}
