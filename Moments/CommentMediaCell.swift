//
//  CommentMediaCell.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 16/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit

class CommentMediaCell: UITableViewCell {

   
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameText: UIButton!
    
    @IBOutlet weak var TextComment: UILabel!
    
    
    var commemt: Comment! {
        didSet{
            self.updateUI()
        }
        
    }
    
    
    
    func updateUI() {
        
        
        profileImageView.image = UIImage(named: "icon-defaultAvatar")
        TextComment.text = self.commemt.text
        usernameText.setTitle(commemt.createdBy.username, for: [])
        
        commemt.createdBy.downloadProfilePic { (image, error) in
            self.profileImageView.image = image
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        
    }

}
