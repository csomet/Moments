//
//  Message.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 23/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import Foundation
import Firebase

public struct MessageType {
        static let text = "text"
        static let video = "video"
        static let image = "image"
}

class Message {
    
    
    var ref: DatabaseReference
    var uid: String
    var senderName: String
    var senderUID: String
    var lastUpdate: Date
    var type: String
    var text: String
    
    
    init (senderUID: String, senderName: String, type: String, text: String){
        
        self.ref = FBDataBaseReference.messages.reference().childByAutoId()
        self.uid = ref.key
        self.senderUID = senderUID
        self.senderName = senderName
        self.lastUpdate = Date()
        self.text = text
        self.type = type
        
    }
    
    init (dictionary: [String: Any]){
        
        self.uid = dictionary["uid"] as! String
        self.text = dictionary["text"] as! String
        self.type = dictionary["type"] as! String
        self.senderName = dictionary["senderName"] as! String
        self.senderUID = dictionary["senderUID"] as! String
        self.ref = FBDataBaseReference.messages.reference().child(uid)
        self.lastUpdate = Date(timeIntervalSince1970: dictionary["lastUpdate"] as! Double)
        
        
    }
    
    
    func save (){
        
        ref.setValue(toDictionary())
    }
    
    
    func toDictionary()-> [String: Any] {
        
        return [
            
            "uid" : uid,
            "text" : text,
            "type" : type,
            "senderName" : senderName,
            "senderUID" : senderUID,
            "lastUpdate" : lastUpdate.timeIntervalSince1970
        
        ]
        
    }
    
}

extension Message: Equatable {}

func == (lhs: Message, rhs: Message)-> Bool{
    return lhs.uid == rhs.uid
}
