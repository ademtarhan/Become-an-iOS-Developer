//
//  AddPresenter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 27.07.2022.
//

import Foundation
import UIKit

protocol AddPresenter: AnyObject {
    func savePost(postText: String)
    func saveImage(postImage: UIImageView,postText: String)
}

class AddPresenterImpl: AddPresenter {
    var interactor: AddInteractor?
    var view: AddViewControllerImpl?

    init(view: AddViewControllerImpl) {
        self.view = view
        interactor = AddInteractorImpl()
    }

    func saveImage(postImage: UIImageView, postText: String) {
        interactor?.saveImage(postImage: postImage, completion: { result in
            switch result {
            case .success:
                print("image saved")
                // self.view?.updateUI(message: "Success")
                self.interactor?.savePost(postText: postText, completion: { result in
                    switch result {
                    case let .success(model):
                        self.view?.updateUI(message: "Success")
                        self.view?.navigationToHome()
                    case let .failure(error):
                        print("error \(error.localizedDescription)")
                    }
                })
            case .failure:
                print("error-save data")
                self.view?.updateUI(message: "Fail")
            }
        })
    }

    func savePost(postText: String) {
        if postText == "" {
            print("text is empty")
            view?.showEmptyTextAlert()
        } else {
            interactor?.savePost(postText: postText, completion: { result in
                switch result {
                case let .success(post):
                    print(post)
                    self.view?.navigationToHome()
                case let .failure(error):
                    print(error)
                }
            })
        }
    }
}
