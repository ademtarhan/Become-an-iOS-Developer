//
//  AddInteractor.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 27.07.2022.
//

import Foundation
import UIKit

protocol AddInteractor: AnyObject {
    func savePost(postText: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func saveImage(postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
}

class AddInteractorImpl: AddInteractor {
    var service: FirebaseService?

    init() {
        service = FirebaseServiceImpl()
    }

    func saveImage(postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.saveImage(postImage: postImage, completion: { result in
            switch result {
            case .success(true):
                completion(.success(true))
            case let .failure(error):
                completion(.failure(error))
            case .success(false):
                break
            }
        })
    }

    let baseURl: String = "https://firebasestorage.googleapis.com/v0/b/deleteuserdatafirebase.appspot.com/o/"

    func savePost(postText: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        var imageUrl = ""
        service?.downUrl(postID: service?.postid ?? "", completion: { result in
            
            switch result{
            case let .success(url):
                imageUrl = url.absoluteString
                print("success url")
            case .failure(_):
                print("FAİL")
                break
            }
        })
        
        let post = DataModel(postText: postText, uID: service?.userid ?? "", postID: service?.postid ?? "", imageURL: imageUrl)
        
        service?.saveData(data: post, completion: { result in
            switch result {
            case let .success(post):
                completion(.success(post))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
