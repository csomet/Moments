//
//  FBReference.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 12/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import Foundation
import Firebase


enum FBDataBaseReference{
    
    case root
    case users(uid: String)
    case media //Posts in the app
    case chats
    case messages
    
    
    
    private var rootRef: DatabaseReference{
        return Database.database().reference()
    }
    
    
    
    //MARK: - Variables for each item data
    private var path: String{
        
        switch self{
            
        case .root:
            return ""
            
        case .users(let uid):
            return "users/\(uid)"
        case .media:
            return "media"
        case .chats:
            return "chats"
        case .messages:
            return "messages"
            
        }
    }
    
    
    //MARK: - Public
    
    func reference() -> DatabaseReference{
        return rootRef.child(path)
    }
    
    
    
    
    
}


enum FBStorage{
    
    case root
    case images
    case profileImages
    
    private var baseRef: StorageReference{
        return Storage.storage().reference()
    }
    
    
    private var path: String{
        
        switch self{
            
        case .root:
            return ""
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
        }
    }
    
    
   //MARK: - Public
    
    func reference() -> StorageReference{
        return baseRef.child(path)
    }
    
}

