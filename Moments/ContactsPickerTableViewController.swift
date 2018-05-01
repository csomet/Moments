//
//  ContactsPickerTableViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 24/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

class ContactsPickerTableViewController: UITableViewController, VENTokenFieldDataSource, VENTokenFieldDelegate {

    var accounts = [User]()
    var currentUser: User!
    var chats: [Chat]!
    var selectedAccount = [User]()
    @IBOutlet weak var contactsPickerField: VENTokenField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
        let firstNVC = tabBarController.viewControllers?.first as! UINavigationController
        let newsFeedTVC = firstNVC.topViewController as! NewsFeedTableViewController
        
        currentUser = newsFeedTVC.currentUser
        
        contactsPickerField.placeholderText = "Search..."
        contactsPickerField.setColorScheme(UIColor.red)
        contactsPickerField.delimiters = [",", ";", ":"]
        contactsPickerField.toLabelTextColor = UIColor.black
        contactsPickerField.dataSource = self
        contactsPickerField.delegate = self
        
        fetchUsers()

    }

 
    func addRecipient (account: User){
        self.selectedAccount.append(account)
        self.contactsPickerField.reloadData()
        
    }
    
    
    func deleteRecipent(account: User, index: Int){
        
        self.selectedAccount.remove(at: index)
        self.contactsPickerField.reloadData()
    }
    
    
    @IBAction func nextDidTap(){
        
        var chatAccounts = selectedAccount
        chatAccounts.append(currentUser)
        var title = ""
        
        if let chat = findChat(allchats: chatAccounts) {
            self.performSegue(withIdentifier: "ShowChatViewController", sender: chat)
        } else {
            
            
            for acc in chatAccounts{
                
                if title == ""{
                        title += "\(acc.fullName)"
                } else {
                    
                    title += ", \(acc.fullName)"
                }
            }
            
        }
        
        let newChat = Chat(users: chatAccounts, title: title, featuredImageUID: chatAccounts.first!.uid)
        self.performSegue(withIdentifier: "ShowChatViewController", sender: newChat)
    }
    
    
    func findChat(allchats: [User]) -> Chat?{
        
        var result: Chat!
        
        if chats == nil { return nil }
            
        for chat in chats {
            
            var results = [Bool]()
            
            for acc in allchats{
                
                let result = chat.users.contains(acc)
                results.append(result)
            }
            
            if !results.contains(false){
                
                result = chat
                
            }
            
        }
    
    
        return result
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowChatViewController" {
            
            let newChat = sender as! Chat
            let chatVC = segue.destination as! ChatViewController
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.fullName
            chatVC.chat = newChat
            chatVC.currentUser = self.currentUser
            chatVC.hidesBottomBarWhenPushed = true
            
        }
    }
    
    
    func fetchUsers() {
        
        let accountsRef = FBDataBaseReference.users(uid: currentUser.uid).reference().child("follows")
        accountsRef.observe(.childAdded, with: { (snap) in
            
            let user = User(dictionary: snap.value as! [String: Any])
            self.accounts.insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
        })
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        cell.added = !cell.added
        
        if cell.added{
            
            self.addRecipient(account: cell.user)
        } else {
            let index = selectedAccount.index(of: cell.user)
            self.deleteRecipent(account: cell.user, index: index!)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accounts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactsTableViewCell
        
        let user = accounts[indexPath.row]
        
        cell.user = user
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
        
        
        return cell
    }
    
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        
        return selectedAccount[Int(index)].fullName
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(selectedAccount.count)
    }
    

    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        
        
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        
        let indexPath = IndexPath(row: Int(index), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        
        cell.added = !cell.added
        self.deleteRecipent(account: cell.user, index: Int(index))
        
        
        
    }
    
    
   }

