//
//  HomeInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomeInteractor: AnyObject {
    func saveData(with child: String, with data: [String: String], completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func save(text: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
}

class HomeInteractorImpl: HomeInteractor {
    func save(text: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        //..TODO: get userid get postid get child
    }
    
    
    func saveData(with child: String, with data: [String: String], completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
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

    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        service?.getData(completion: { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.deleteData(with: data, postID: postID, completion: { result in
            switch result {
            case let .success(true):
                completion(.success(true))
            case let .failure(error):
                print(error)
                completion(.failure(.timeOut))
            case .success(false):
                break
            }
        })
    }
}
