//
//  ChatTableViewCell.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 23/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import SAMCache

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var cache = SAMCache.shared()
    
    var chat: Chat! {
        
        didSet{
            
            self.updateUI()
        }
    }


    func updateUI() {
        
        if let image = cache?.object(forKey: "\(chat.uid)-featuredImage") {
            
            self.featuredImageView.image = image as? UIImage
            self.featuredImageView.layer.cornerRadius = self.featuredImageView.bounds.width / 2.0
            self.featuredImageView.layer.masksToBounds = true
       
        } else {
    
            chat.downloadFeaturedImage { (image, error) in
                if error == nil {
                    
                    self.featuredImageView.image = image
                    self.cache?.setObject(image, forKey: "\(self.chat.uid)-featuredImage")
                    
                }else {
                    print("\(error?.localizedDescription ?? "Error")")
                }
                
                self.featuredImageView.layer.cornerRadius = self.featuredImageView.bounds.width / 2.0
                self.featuredImageView.layer.masksToBounds = true
                
            }
            
        }
        
        self.lastMessageLabel.text = chat.lastMessage
        self.titleLabel.text = chat.title
    
    
    }
    
    
    
}
