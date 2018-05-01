//
//  Chat.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 23/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase



class Chat {
    
    
    
    var uid: String
    var ref: DatabaseReference
    var lastMessage: String
    var users: [User]
    var lastUpdate: Double
    var messageIDs: [String]
    var title: String
    var featuredImageUID: String
    
    
    init (users: [User], title: String, featuredImageUID: String)
    {
        
        self.users = users
        self.title = title
        self.lastUpdate = Date().timeIntervalSince1970
        self.messageIDs = []
        self.lastMessage = ""
        
        self.ref = FBDataBaseReference.chats.reference().childByAutoId()
        self.uid = ref.key
        
        self.featuredImageUID = featuredImageUID
        
    }
    
    
    init (dictionary: [String: Any]){
        
        self.title = dictionary["title"] as! String
        self.lastUpdate = dictionary["lastUpdate"] as! Double
        self.lastMessage = dictionary["lastMessage"] as! String
        self.featuredImageUID = dictionary["featuredImageUID"] as! String
        self.uid = dictionary["uid"] as! String
        self.ref = FBDataBaseReference.chats.reference().child(uid)
        
        users = []
        
        if let usersDict = dictionary["users"] as? [String: Any]{
            
            for (_, userDic) in usersDict {
                if let userDic = userDic as? [String: Any]{
                    self.users.append(User(dictionary: userDic))
                }
            }
        }
        
        messageIDs = []
        
        if let messageIDsDict = dictionary["messageIDs"] as? [String: Any]{
            
            for (_, messageID) in messageIDsDict{
                
                if let messageID = messageID as? String {
                    messageIDs.append(messageID)
                }
            }
        }
        
        
        
        
    }
    
    
    
    func save() {
        
        ref.setValue(toDictionary())
        
        let usersRef = ref.child("users")
        
        for user in users {
            usersRef.child(user.uid).setValue(user.toDictionary())
            
        }
        
        let messageIdRef = ref.child("messageIDs")
        for message in messageIDs {
            messageIdRef.childByAutoId().setValue(message)
        }
        
        
    }
    
   
    //MARK: - Returns all users that participate in the chat
    func getUsers() -> [User] {
        
        return users
    }
    
    func toDictionary() -> [String: Any]{
        
         return [
            
            "uid" : uid,
            "lastMessage" : lastMessage,
            "lastUpdate" : lastUpdate,
            "title" : title,
            "featuredImageUID" : featuredImageUID
        ]
    }
    
    
    
}


extension Chat: Equatable {
    
    func downloadFeaturedImage(completion: @escaping (UIImage?, Error?)-> Void ){
        
        FBIMage.downloadProfileImage(self.featuredImageUID) { (image, error) in
            
            completion(image, error)
        }
    }
    
    
    func sendMessage(message: Message){
        
        self.messageIDs.append(message.uid)
        self.lastMessage = message.text
        self.lastUpdate = Date().timeIntervalSince1970
        
        ref.child("lastUpdate").setValue(lastUpdate)
        ref.child("lastMessage").setValue(lastMessage)
        ref.child("messageIDs").childByAutoId().setValue(message.uid)
        
    }
    
}

func ==(lhs:Chat, rhs:Chat) ->Bool{
    
    return lhs.uid == rhs.uid
}
