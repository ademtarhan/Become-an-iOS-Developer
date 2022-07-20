//
//  LogInRouter.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation

class LogInRouter{
    public static var shared = LogInRouter()
    
    var login: LogInViewController{
        LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
    }
    
}
