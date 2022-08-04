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
    case deleteDeviceError
    case deleteAquariumError
    case deleteAccountError
    case removeValueError
    case deleteUserError
    case fetchAquariumsError
    case fetchDevicesError
    case networkError
}

struct Stack {
    private var items = [String]()

    func peek() -> String {
        guard let topElement = items.first else { fatalError("This stack is empty.") }
        return topElement
    }

    mutating func pop() -> String {
        return items.removeFirst()
    }

    mutating func push(_ element: String) {
        items.insert(element, at: 0)
    }
}
