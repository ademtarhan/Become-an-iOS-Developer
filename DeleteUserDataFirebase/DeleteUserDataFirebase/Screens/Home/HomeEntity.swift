//
//  HomeEntity.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import Foundation

struct HomeEntity {
    var text: String
    var userid: String

    func asJson() -> [String: Any] {
        return [
            "text": text,
            "userid" : userid,
        ]
    }
}

enum HomeError: Error {
    case timeOut
    case invalidData
}


struct DataModel{
    var text: String
    var uid: String
}
