//
//  ProfileViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 14/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import SAMCache
import Firebase

class ProfileViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextView: UILabel!
    @IBOutlet weak var followedByTextView: UILabel!
    @IBOutlet weak var followTextView: UILabel!
    
    var cache = SAMCache.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let fistVC = tabBarController.viewControllers?.first as! UINavigationController
        let newsFeed = fistVC.topViewController as! NewsFeedTableViewController
        
        nameTextView.text = newsFeed.currentUser.fullName
        
        followTextView.text = "\(newsFeed.currentUser.follows.count)"
        followedByTextView.text = "\(newsFeed.currentUser.followedBy.count)"
        
        
        if let image = cache?.object(forKey: "\(newsFeed.currentUser.uid)-headerImage") as? UIImage {
            
            profileImageView.image = image
            
        } else {
            
            newsFeed.currentUser.downloadProfilePic(completion: { (image, error) in
                
                if error == nil {
                    self.profileImageView.image = image
                } else {
                    print(error?.localizedDescription ?? "")
                }
                
                self.cache?.setObject(image, forKey:"\(newsFeed.currentUser.uid)-headerImage")
                
            })
            
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
    }

 
    @IBAction func logout(_ sender: UIBarButtonItem) {
    
        try! Auth.auth().signOut()
        self.tabBarController?.selectedIndex = 0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let thirdVC = tabBarController.viewControllers?[2] as! UINavigationController
        let inboxTVC = thirdVC.topViewController as! InboxTableViewController
        
        inboxTVC.userSignedOut()
   
        

    
    }
    
    @IBAction func cleanCache(){
        cache?.removeAllObjects()
        
    }
}
