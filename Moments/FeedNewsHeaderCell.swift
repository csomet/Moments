//
//  FeedNewsHeaderCell.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 15/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import SAMCache

class FeedNewsHeaderCell: UITableViewCell {

   
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var buttonUsername: UIButton!
    
    @IBOutlet weak var buttonFollow: UIButton!
    
    var cache = SAMCache.shared()
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
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func updateUI() {
        
        
        
        self.profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        if let imageCache = cache?.object(forKey: "\(self.media.createdBy.uid)-headerImage") as? UIImage{
            
            self.profileImageView.image = imageCache
        
        } else {
        
            media.createdBy.downloadProfilePic {  (image, error) in
                
                if let image = image {
                    self.profileImageView.image = image
                    self.cache?.setObject(image, forKey: "\(self.media.createdBy.uid)-headerImage")
                    
                }else {
                    print("\(String(describing: error?.localizedDescription))")
                }
                
                
            }
            
        }
        
        self.profileImageView.layer.cornerRadius = (self.profileImageView.bounds.width) / 2.0
        self.profileImageView.layer.masksToBounds = true
        
        
        self.buttonFollow.layer.borderWidth = 1
        self.buttonFollow.layer.cornerRadius = 2.0
        self.buttonFollow.layer.borderColor = self.buttonFollow.tintColor.cgColor
        self.buttonFollow.layer.masksToBounds = true
        
        if self.media.createdBy.uid == self.currentUser.uid {
            
            self.buttonFollow.isHidden = true
            
        } else {
            self.buttonFollow.isHidden = false
            
        }
        
        if  currentUser.follows.contains(media.createdBy){
            buttonFollow.setTitle("   Unfollow   ", for: [])
        }else{
            buttonFollow.setTitle("   Follow   ", for: [])
        }
        
        
        self.buttonUsername.setTitle("\((self.media.createdBy.username as String?)!)", for: [])
    }
    
    @IBAction func followUser() {
        
        if !currentUser.follows.contains(media.createdBy){
            currentUser.follow(user: media.createdBy)
            media.createdBy.isfollowedBy(user: currentUser)
            buttonFollow.setTitle("   Unfollow   ", for: [])
            
        }else{
            
            currentUser.unfollow(user: media.createdBy)
            media.createdBy.isUnfollowBy(user: currentUser)
            buttonFollow.setTitle("   Follow   ", for: [])
            
        }
    }

}
