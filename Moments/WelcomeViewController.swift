//
//  WelcomeViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 13/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.dismiss(animated: false, completion: nil)
                
            } else {
                
            }
        })
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

}
