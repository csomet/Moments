//
//  MediaDetailTableView.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 16/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase

class MediaDetailTableView: UITableViewController {

    var media: Media!
    var currentUser: User!
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        navigationItem.title = "Details Media"
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 597
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = media.comment
        tableView.reloadData()
        
        //self.fetchComments ()
            
        
        
    
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //fetchComments()
        tableView.reloadData()
    }
    
    func fetchComments(){
        
            media.observeNewComment { (comment) in
            
                if !self.comments.contains(comment){
                    self.comments.insert(comment, at: 0)
                    self.tableView.reloadData()
                    
                }
        }
        
    }

    
    // MARK: - Target / Action
    
    @IBAction func commentDidTap() {
        self.performSegue(withIdentifier: "ShowCommentComposer", sender: media)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommentComposer" {
            let commentComposer = segue.destination as! ComposerViewController
            commentComposer.media = media
            commentComposer.currentUser = currentUser
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.row == 0 {
            //media row
            let cellMedia = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaTableViewCell
            
            cellMedia.currentUser = currentUser
            cellMedia.media = media
            
            return cellMedia
        
        } else {
            //comment row
            let cellCom = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentMediaCell
            
            tableView.separatorStyle = .none
            
            cellCom.commemt = comments[indexPath.row - 1]
            
            return cellCom
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! FeedNewsHeaderCell
        cell.currentUser = currentUser
        cell.media = media
        cell.backgroundColor = UIColor.white
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 57
    }
}
