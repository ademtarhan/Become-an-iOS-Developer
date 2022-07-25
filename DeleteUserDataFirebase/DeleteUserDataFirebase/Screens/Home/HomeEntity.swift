//
//  HomeEntity.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 21.07.2022.
//

import FirebaseCore
import FirebaseDatabase
import Foundation

struct HomeEntity {
    var text: String
    var userid: String

    func asJson() -> [String: Any] {
        return [
            "text": text,
            "userid": userid,
        ]
    }
}

enum HomeError: Error {
    case timeOut
    case invalidData
}

struct DataModel {
    var text = ""
    var uid = ""
    var postid = ""
    
    init(text: String,uid: String,postid: String){
        self.text = text
        self.uid = uid
        self.postid = postid
    }

    init(snapShot: [String: Any]) {
        self.text = snapShot["text"] as! String
        self.uid = snapShot["userid"] as! String
        self.postid = snapShot["postid"] as! String
    }
}
