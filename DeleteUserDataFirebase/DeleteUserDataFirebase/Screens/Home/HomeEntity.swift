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
    var postText = ""
    var uID = ""
    var postID = ""
    var imageURL = ""
    
    var asJson: [String: Any] {
        return ["postText":postText, "userID":uID,"postID":postID,"imageURL":imageURL]
    }
    
    init(postText: String,uID: String,postID: String,imageURL: String){
        self.postText = postText
        self.uID = uID
        self.postID = postID
        self.imageURL = imageURL
    }

    init(snapShot: [String: Any]) {
        self.postText = snapShot["postText"] as! String
        self.uID = snapShot["userID"] as! String
        self.postID = snapShot["postID"] as! String
        self.imageURL = snapShot["imageURL"] as! String
    }
}
