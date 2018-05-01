//
//  NewsFeedTableViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 13/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase
import SAMCache

class NewsFeedTableViewController: UITableViewController, UITabBarControllerDelegate {

    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User!
    var media = [Media]()
    
    var cache = SAMCache.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // check if the user logged in or not
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                FBDataBaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        self.currentUser = User(dictionary: userDict)
                    }
                    
                    self.fetchMedia()
                    self.cache?.removeAllObjects()
                })
                
            } else {
                self.performSegue(withIdentifier: "ShowWelcomeViewController", sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self
        
        tableView.estimatedRowHeight = 597
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        
        
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  tableView.reloadData()
    }

    
    func fetchMedia (){
        
        self.media = [Media]()
        
        Media.observeNewMedia { (media) in
            
          /* if media.createdBy.username == "jdoe" && !self.currentUser.follows.contains(media.createdBy) && self.currentUser.username != "jdoe"{
                self.currentUser.follow(user: media.createdBy)
                media.createdBy.isfollowedBy(user: self.currentUser)
            }*/
            
            if (!self.media.contains(media)){
                
                if (self.currentUser != nil){
                    if self.currentUser.follows.contains(media.createdBy) || media.createdBy.uid == self.currentUser.uid {
                        self.media.insert(media, at: 0)
                    }
                }else{
                   // self.media.insert(media, at: 0)
                }
                
                
                
            }
            
            self.tableView.reloadData()
                
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowMediaDetail" {
            
            let mediaDetailTVC = segue.destination as! MediaDetailTableView
            
            if let selectedIndex = tableView.indexPathForSelectedRow {
                
                mediaDetailTVC.currentUser = currentUser
                mediaDetailTVC.media = media[selectedIndex.section]
            }
        } else if segue.identifier == "ShowCommentComposer"{
                let commentComposer = segue.destination as! ComposerViewController
                let mediaToSend = sender as! Media
                commentComposer.currentUser = currentUser
                commentComposer.media = mediaToSend
            
            
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        if let _ = viewController as? DummyPostComposer {
            
             imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostComposerView") as! UINavigationController
                
                let postComposer = postComposerVC.topViewController as! PostComposerTViewController
                
                postComposer.image = image
                self.present(postComposerVC, animated: true, completion: nil)
                
                
                
            })
            
           return false
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return media.count
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if media.count == 0 {
            return 0
        }else {
            return 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexpath) as! MediaTableViewCell
        
        cell.currentUser = currentUser
        cell.media = media[indexpath.section]
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! FeedNewsHeaderCell
        cell.currentUser = currentUser
        cell.media = media[section]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
        self.performSegue(withIdentifier: Data.showMediaDetail, sender: nil)
        
        
    }
    
    

   }

extension NewsFeedTableViewController: MediaTableViewCellDelegate{
    
    func commentButtonDidTap(media: Media) {
        
        self.performSegue(withIdentifier: Data.showCommComposer, sender: media)
    }
}
