//
//  HomeRouter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation

class HomeRouter{
    public static var shared = HomeRouter()
    var home: HomeViewController{
        HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
    }
    
    var router: DeleteAccountViewController{
        DeleteAccountViewControllerImpl(nibName: "DeleteAccountViewController", bundle: nil)
    }
}
