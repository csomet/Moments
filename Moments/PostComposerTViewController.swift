//
//  PostComposerTViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 15/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit

class PostComposerTViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var caption: UITextView!
    
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var image: UIImage!
    var imagePickerSourceType: UIImagePickerControllerSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        caption.becomeFirstResponder()
        caption.text = ""
        caption.delegate = self
        
        shareBarButtonItem.isEnabled = false
        
        imageView.image = self.image
        
        tableView.allowsSelection = false


    }

    
   

    
    @IBAction func goDidTap(_ sender: UIBarButtonItem){
        
        if let image = image, let text = caption.text{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
            let firstNVC = tabBarController.viewControllers?.first as! UINavigationController
            let newsFeedTV = firstNVC.topViewController as! NewsFeedTableViewController
            
            if let currentUser = newsFeedTV.currentUser {
                
                let newMedia = Media(caption: text, type: "image", createdBy: currentUser, image: image)
                
                newMedia.save(completion: { (error) in
                    if error != nil {
                        
                        let alert = UIAlertController(title: "Error creating post", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(alertAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    
                    } else {
                       currentUser.share(newMedia: newMedia)
                        
                    }
                })
                
            }
        }
            self.cancelDidTap()
    }
    
    
    
    
    @IBAction func cancelDidTap() {
    
        self.image = nil
        imageView.image = nil
        caption.resignFirstResponder()
        caption.text = ""
        
        self.dismiss(animated: true, completion: nil)
        
    
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if caption.text != "" {
            shareBarButtonItem.isEnabled = true
            
        } else {
            shareBarButtonItem.isEnabled = false
        }
        
    }
    
    


}
