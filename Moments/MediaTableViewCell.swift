//
//  MediaTableViewCell.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 15/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import SAMCache


protocol MediaTableViewCellDelegate: class {
    func commentButtonDidTap(media: Media)
}

class MediaTableViewCell: UITableViewCell {

    
  
    @IBOutlet weak var viewCommentsText: UIButton!
    @IBOutlet weak var post: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var captionMedia: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    
    var cache = SAMCache.shared()
    weak var delegate: MediaTableViewCellDelegate? 
    var currentUser: User!
    var media: Media! {
        
        didSet{
            if currentUser != nil{
                updateUI()
            }
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(){
    
        self.post.image = nil
        
        if let imageCache = cache?.object(forKey: "\(self.media.uid)-post"){
            
            self.post.image = imageCache as? UIImage
            
        } else {
        
            media.downloadMedia { (image, error) in
                
                if let imageDownloaded = image {
                    
                    self.post.image = imageDownloaded
                    self.cache?.setObject(imageDownloaded, forKey: "\(self.media.uid)-post")
                    
                }
                
                
                
            }
            
        }
        
        self.likeButton.setImage(UIImage(named: "icon-like"), for: [])
        
        self.captionMedia.text = self.media.caption
        
        if self.media.likes.count == 0 {
            
            self.likesButton.setTitle("Be the first to like this thit!", for: [])
            
        } else{
            
            self.likesButton.setTitle("♥︎ \(String(describing: self.media.likes.count)) likes", for: [])
            
            if (self.media.likes.contains((self.currentUser)!)){
                self.likeButton.setImage(UIImage(named: "icon-like-filled"), for: [])
            }
        }
        
        
        if self.media.comment.count == 0 {
            
            self.viewCommentsText.setTitle("No comments yet", for: [])
            
        } else if self.media.comment.count == 1 {
            
            self.viewCommentsText.setTitle("View 1 comment", for: [])
            
        } else {
            
            self.viewCommentsText.setTitle("view \(String(describing: self.media.comment.count)) comments", for: [])
        }

        
    }
    
    
    @IBAction func shareButtonDidTap() {
        
    }
    

    @IBAction func commentButtonDidTap() {
        delegate?.commentButtonDidTap(media: media)
        
    }
   
    
    @IBAction func likesButtonDidTap() {
        
        
        
    }
    
    
    @IBAction func viewCommentsDidTap() {
        
        
    }
    
    
    @IBAction func likeButtonDidTap(){
        
        if !media.likes.contains(currentUser){
            media.likeBy(user: currentUser)
            likeButton.setImage(UIImage(named: "icon-like-filled"), for: [])
            self.likesButton.setTitle("♥︎ \(String(describing: self.media.likes.count)) likes", for: [])
            
        }else{
             media.unlikeBy(user: currentUser)
             likeButton.setImage(UIImage(named: "icon-like"), for: [])
            if media.likes.count == 0 {
                 self.likesButton.setTitle("Be the first to like this thit!", for: [])
            }else{
                self.likesButton.setTitle("♥︎ \(String(describing: self.media.likes.count)) likes", for: [])
            }
        }
    }
   
}
