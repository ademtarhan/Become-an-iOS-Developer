//
//  HomeInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

protocol HomeInteractor: AnyObject {
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func saveItem(text: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteAccount(completion: @escaping (Result<Any, FirebaseError>) -> Void)
}

class HomeInteractorImpl: HomeInteractor {
    var service: FirebaseService?
    var deleteFirebaseService: FirebaseDeleteService?

    init() {
        service = FirebaseServiceImpl()
        deleteFirebaseService = FirbaseDeleteServiceImpl()
    }

    func deleteAccount(completion: @escaping (Result<Any, FirebaseError>) -> Void) {
        deleteFirebaseService?.delete({ result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                print("failure-interactor")
                completion(.failure(.deleteAccountError))
            }
        })    }

    // ..MARK: save item
    func saveItem(text: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        let post = DataModel(postText: text, uID: service?.userid ?? "", postID: service?.postid ?? "", imageURL: "")
        service?.saveData(data: post, completion: { result in
            switch result {
            case let .success(post):
                completion(.success(post))
            case .failure:
                completion(.failure(.timeOut))
            }
        })
    }

    // ..MARK: get data
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

    // ..MARK: delete data
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
