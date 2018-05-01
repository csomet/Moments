//
//  User.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 12/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import Foundation
import Firebase



class User {
    
    
    
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    var follows: [User]
    var followedBy: [User]
    
    
    init(dictionary: [String: Any]){
        
        self.uid = dictionary["uid"] as! String
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        self.bio = dictionary["bio"] as! String
        self.website = dictionary["website"] as! String
        self.follows = []
        
        if let followsDict = dictionary["follows"] as? [String: Any]{
            
            for (_, userDict) in followsDict {
                
                if let userDict = userDict as? [String: Any]{
                    self.follows.append(User(dictionary: userDict))
                }
                
            }
        }
        
        self.followedBy = []
        
        if let followedByDict = dictionary["followedBy"] as? [String: Any]{
            
            for (_, userDict) in followedByDict {
                
                if let userDict = userDict as? [String: Any]{
                    self.followedBy.append(User(dictionary: userDict))
                }
                
            }
        }

        
        
        
        
    }
    
    
    init(uid: String, username: String, fullName: String, bio: String, website: String, profileImage: UIImage?, follows: [User], followedBy: [User]){
        
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.follows = follows
        self.followedBy = followedBy
        self.profileImage = profileImage
    
    }
    
    
    
    func save(completion: @escaping  (Error?) -> Void) {
        
        //1. Save user
        let ref = FBDataBaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
        
        
        //2. Save follows users
        
        for user in follows{
            
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
    
        //3. Save followed by
        
        for user in followedBy{
            
            ref.child("followedBy\(user.uid)").setValue(user.toDictionary())
        }
        
        
        //4. Save profile Pic.
        if let profileImage = self.profileImage {
            
            let firImage = FBIMage(image: profileImage)
            
            firImage.saveProfileImage(self.uid, { (error) in
                completion(error)
                
            })
            
            
        }
        
        
        
    }
    
    func save(new chat: Chat){
        
        FBDataBaseReference.users(uid: self.uid).reference().child("chatIds/\(chat.uid)").setValue(true)
    }
    
    
    func toDictionary() -> [String: Any]{
        
        return [
        
            "uid" : uid,
            "username" : username,
            "fullName" : fullName,
            "bio" : bio,
            "website" : website
        ]
        
    }
    
    
    
}


extension User: Equatable {
    
    func share(newMedia: Media){
        
        FBDataBaseReference.users(uid: uid).reference().child("media").childByAutoId().setValue(newMedia.uid)
        //Only save the media uid not the media itself.
    }
    
    
    func downloadProfilePic(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FBIMage.downloadProfileImage(uid) { (image, error) in
        self.profileImage = image
        completion(image, error)
            
        }
    }
    
    func follow(user: User){
        
        follows.append(user)
        FBDataBaseReference.users(uid: uid).reference().child("follows/\(user.uid)").setValue(user.toDictionary())
        
    }
    
    func unfollow(user: User){
        
        if let index = follows.index(of: user){
            follows.remove(at: index)
            FBDataBaseReference.users(uid: uid).reference().child("follows/\(user.uid)").setValue(nil)
        }
    }
    
    
    
    func isfollowedBy(user: User){
        
        followedBy.append(user)
        FBDataBaseReference.users(uid: uid).reference().child("followedBy/\(user.uid)").setValue(user.toDictionary())
        
    }
    
    func isUnfollowBy(user: User){
        
        if let index = follows.index(of: user){
            follows.remove(at: index)
            FBDataBaseReference.users(uid: uid).reference().child("followedBy/\(user.uid)").setValue(nil)
        }
    }
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}
