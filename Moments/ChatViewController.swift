//
//  ChatViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 27/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SAMCache

class ChatViewController: JSQMessagesViewController {

   
    var currentUser: User!
    var chat: Chat!
    var messagesRef = FBDataBaseReference.messages.reference()
    var messages = [Message]()
    var jsqMessages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var soundActive = false
    
    var cache = SAMCache.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chat.title
        self.setUpBubbleImages()
        self.setUpAvatarImages()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.observeMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
           
            self.soundActive = true
            
        })
        
    }
    

    
  
    
    @objc func back (_ sender: UIBarButtonItem){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func setUpBubbleImages() {
        
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
    }
    
    
    func setUpAvatarImages(){
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 32, height: 32)
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 32, height: 32)
        
        
        
    }

  
    /*override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 10
    }*/
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        //collection view has item no row.
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
       
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            
            cell.textView.textColor = UIColor.white
           
        } else {
            
            cell.textView.textColor = UIColor.black
            
        }
        
        return cell
    }
    
  /*  override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let jsqMessage = jsqMessages[indexPath.item]
        
        let name = jsqMessage.senderDisplayName.components(separatedBy: " ")
        return NSAttributedString(string: name[0])
    }*/
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            
           return outgoingBubbleImageView
            
        }else {
            
           return incomingBubbleImageView
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        if let avatarImage = cache?.object(forKey: "\(messages[indexPath.item].senderUID)-headerImage") as? UIImage{
    
            let jsqAvatar  = JSQMessagesAvatarImageFactory.avatarImage(with: avatarImage, diameter: 32)
            return jsqAvatar
        
        }else {
            
            let defaultAvatar = UIImage(named: "icon-defaultAvatar")
            let jsqAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: defaultAvatar, diameter: 32)
            return jsqAvatar
        }
        
 
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if chat.messageIDs.count == 0{
            
            chat.save()
            
            for account in chat.users{
                
                account.save(new: chat)
            }
            
        }
        
        let newMessage = Message(senderUID: currentUser.uid, senderName: currentUser.fullName, type: "text", text: text)
        newMessage.save()
        chat.sendMessage(message: newMessage)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage(animated: true)
        
        
    }
    
    
    func observeMessages() {
        
        let chatMessageIdsRef = self.chat.ref.child("messageIDs")
        chatMessageIdsRef.observe(.childAdded, with: { (snap) in
            
            let messageId = snap.value as! String
            
            FBDataBaseReference.messages.reference().child(messageId).observe(.value, with: { (snapshot) in
                
                let message = Message(dictionary: snapshot.value as! [String: Any])
                
                self.messages.append(message)
                self.add(message)
                
                
                if self.currentUser.uid != message.senderUID && self.soundActive{
                    JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                }
                
                self.finishReceivingMessage(animated: true)
               
            })

        })
        
        
    }
    
    func add(_ message: Message){
        
        if message.type == MessageType.text{
            let jsqMess = JSQMessage(senderId: message.senderUID, displayName: message.senderName, text: message.text)
            jsqMessages.append(jsqMess!)
        }
    }

}
