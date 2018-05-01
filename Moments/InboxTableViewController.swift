//
//  InboxTableViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 12/5/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase

class InboxTableViewController: UITableViewController
{
    var currentUser: User!
    var chats = [Chat]()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
        let newsfeedTVC = firstNavVC.topViewController as! NewsFeedTableViewController
        currentUser = newsfeedTVC.currentUser
        
        self.observeChats()
      
    }
    
    func observeChats() {
        let userChatIdsRef = FBDataBaseReference.users(uid: currentUser.uid).reference().child("chatIds")
        
        userChatIdsRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            let chatId = snapshot.key
            
            // go download that chat
            FBDataBaseReference.chats.reference().child(chatId).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                let chat = Chat(dictionary: snapshot.value as! [String : Any])
                if !self.alreadyAdded(chat) {
                    self.chats.append(chat)
                    let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
    
    func alreadyAdded(_ chat: Chat) -> Bool {
        for c in chats {
            if c.uid == chat.uid {
                return true
            }
        }
        
        return false
    }
    
    func userSignedOut() {
        self.currentUser = nil
        self.chats.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        let chat = chats[(indexPath as NSIndexPath).row]
        
        cell.chat = chat
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - Navigation
    
    struct Storyboard {
        static let showContactsPicker = "ShowContactsPicker"
        static let showChatViewController = "ShowChatViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showContactsPicker {
            let contactsPickerVC = segue.destination as! ContactsPickerTableViewController
            print(self.chats)
            contactsPickerVC.chats = self.chats
        } else if segue.identifier == Storyboard.showChatViewController {
            let chatVC = segue.destination as! ChatViewController
            let chatCell = sender as! ChatTableViewCell
            let chat = chatCell.chat
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.fullName
            chatVC.chat = chat
            chatVC.currentUser = self.currentUser
            chatVC.hidesBottomBarWhenPushed = true
        }
    }
    
}
