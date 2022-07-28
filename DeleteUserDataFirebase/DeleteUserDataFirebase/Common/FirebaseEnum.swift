//
//  FirebaseEnum.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 20.07.2022.
//

import Foundation

enum FirebaseError: Error {
    case timeOut
    case wrongPassword
    case invalidEmail
    case unKnownError
    case documentsError
    case uploadError
    case saveError
}
