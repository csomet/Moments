//
//  ComposerViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 16/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController, UITextViewDelegate {

   
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UIButton!
    
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var commentText: UITextView!
    
    var currentUser: User!
    var media: Media!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        navigationItem.rightBarButtonItem = postBarButtonItem
        navigationItem.title = "Compose your comment"
        
        postBarButtonItem.isEnabled = false
        commentText.text = ""
        commentText.becomeFirstResponder()
        
        commentText.delegate = self
        
        if currentUser.profileImage == nil {
            profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            currentUser.downloadProfilePic(completion: { (image, error) in
                self.profileImageView.image = image
            })
        } else {
            profileImageView.image = currentUser.profileImage
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        usernameLabel.setTitle("\(currentUser.username)", for: [])
        
    }
    
    @IBAction func postDidTap (){
        
        let comment = Comment(mediaUID: media.uid, createdBy: currentUser, text: commentText.text)
        comment.save()
        media.comment.append(comment)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text != ""){
            postBarButtonItem.isEnabled = true
        }else{
            postBarButtonItem.isEnabled = false
        }
    }

  
    


}
