//
//  ContactsTableViewCell.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 23/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import SAMCache

class ContactsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var emailTextView: UILabel!
    
    var cache:SAMCache = SAMCache.shared()
    
    
    var user: User! {
        
        didSet{
                self.updateUI()
        }
    }
    
    var added: Bool = false {
        didSet {
            
            if !added {
                self.checkBoxImage.image = UIImage(named: "icon-checkbox")
            } else {
                    self.checkBoxImage.image = UIImage(named: "icon-checkbox-filled")
            }
            
                
        }
    }
    
    
    
    func updateUI() {
        
        if let image = cache.object(forKey: "\(user.uid)-profileImage") {
            profileImageView.image = image as? UIImage
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
            self.profileImageView.layer.masksToBounds = true

        } else {
        
            user.downloadProfilePic { (image, error) in
                
                if error == nil {
                    self.profileImageView.image = image
                    self.cache.setObject(image, forKey: "\(self.user.uid)-profileImage")
                } else {
                    print("\(error?.localizedDescription ?? "Error")")
                }
                
                self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
                self.profileImageView.layer.masksToBounds = true
            }
        }
        
        
        self.username.text = user.username
        self.checkBoxImage.image = UIImage(named: "icon-checkbox")
        self.emailTextView.text = user.fullName
        
    }

}
