//
//  Media.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 14/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase



class Media {
    
    
    let uid: String
    var caption: String
    var type: String //image video
    var createdTime: Double
    var createdBy: User
    var likes: [User]
    var comment: [Comment]
    var mediaImage: UIImage!
    
    
    init (caption: String, type: String, createdBy: User, image: UIImage) {
        
        self.caption = caption
        self.createdBy = createdBy
        self.mediaImage = image
        
        self.createdTime = Date().timeIntervalSince1970
        self.likes = []
        self.comment = []
        self.type = type
        self.uid = FBDataBaseReference.media.reference().childByAutoId().key
        
    }
    
    
    init (dictionary: [String: Any]) {
        
        self.caption = dictionary["caption"] as! String
        self.type = dictionary["type"] as! String
        self.uid = dictionary["uid"] as! String
        self.createdTime = dictionary["createdTime"] as! Double
        let user = User(dictionary: dictionary["createdBy"] as! [String: Any])
        self.createdBy = user
        
        self.likes = []
        
        if let likesDic = dictionary["likes"] as? [String: Any]{
            
            for (_, userDict) in likesDic {
                
                if let userDict = userDict as? [String: Any]{
                    self.likes.append(User(dictionary: userDict))
                }
                
            }
        }
        
        self.comment = []
        
        if let commMedia = dictionary["comments"] as? [String: Any]{
            
            for (_, comm) in commMedia {
                
                if let comm = comm as? [String: Any]{
                    self.comment.append(Comment(dictionary: comm))
                }
                
            }
        }

        
    }
    
    func downloadMedia(completion: @escaping (UIImage?, Error?) -> Void) {
        
       FBIMage.downloadImage(self.uid) { (image, error) in
            completion(image, error)
        }
    }
    
    
    func save (completion: @escaping (Error?) -> Void){
        
        let ref = FBDataBaseReference.media.reference().child(uid)
        ref.setValue(toDictionary())
        
        //save likes
        
        for userLike in likes{
            
            ref.child("likes/\(userLike.uid)").setValue(userLike.toDictionary())
            
        }
        
        
        //save comments
        
        for comm in comment {
            
            ref.child("comments/\(comm.uid)").setValue(comm.toDictionary())
        
        }
        
        
        //upload image
        
        let fbmedia = FBIMage(image: mediaImage)
        fbmedia.saveImage(self.uid) { (error) in
            completion(error)
        }
            
        
       
        
        
    }
    
    
    class func observeNewMedia(_ completion: @escaping (Media) ->Void) {
        
        
        FBDataBaseReference.media.reference().observe(.childAdded, with: { (snap) in
            
            let media = Media(dictionary: snap.value as! [String: Any])
            completion(media)
            
            
        })
    }
    
    
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void) {
        
        FBDataBaseReference.media.reference().child("\(uid)/comments").observe(.childAdded, with: { (snap) in
            let comment = Comment(dictionary: snap.value as! [String: Any])
            completion(comment)
            
        })
        
    }
    
    
    func toDictionary() -> [String: Any]{
        
        return [
        
            "uid" : uid,
            "type": type,
            "caption": caption,
            "createdTime": createdTime,
            "createdBy": createdBy.toDictionary()
        
        ]
    }
    
    
    func likeBy(user: User){
        
        self.likes.append(user)
        FBDataBaseReference.media.reference().child("\(uid)/likes/\(user.uid)").setValue(user.toDictionary())
    }
    
    
    func unlikeBy(user: User){
        
        if let index = likes.index(of: user){
            
            self.likes.remove(at: index)
            FBDataBaseReference.media.reference().child("\(uid)/likes/\(user.uid)").setValue(nil)
        }
    }
    
    
}



class Comment {
    
    var mediaUID: String //ID for the post where is the comment.
    var uid: String //ID of comment itself
    var text: String
    var createdTime: Double
    var createdBy: User
    var ref: DatabaseReference
    
    
    init (mediaUID: String, createdBy: User, text: String){
        
        self.mediaUID = mediaUID
        self.text = text
        self.createdBy = createdBy
        self.createdTime = Date().timeIntervalSince1970
        
        self.ref = FBDataBaseReference.media.reference().child("\(mediaUID)/comments").childByAutoId()
        self.uid = ref.key
    }
    
    
    init (dictionary: [String: Any]){
        
        self.mediaUID = dictionary["mediaUID"] as! String
        self.uid = dictionary["uid"] as! String
        self.text = dictionary["text"] as! String
        self.createdTime = dictionary["createdTime"] as! Double
        let userCreator = dictionary["createdBy"] as! [String: Any]
        self.createdBy = User(dictionary: userCreator)
        ref = FBDataBaseReference.media.reference().child("\(mediaUID)/comments/\(uid)")
        
    }
    

    
    
    func save () {
        
        ref.setValue(toDictionary())
        
    }
    
    
    
    
    func toDictionary() -> [String: Any]{
        
        return [
            "mediaUID": mediaUID,
            "uid": uid,
            "createdBy": createdBy.toDictionary(),
            "createdTime": createdTime,
            "text": text
        ]
    }

    
    
    
}

extension Comment: Equatable {}

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.uid == rhs.uid
}


extension Media: Equatable {}

func ==(lhs: Media, rhs: Media) -> Bool {
    return lhs.uid == rhs.uid
}

