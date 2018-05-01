//
//  LoginScreenTableView.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 13/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase
import SAMCache

class LoginScreenTableView: UITableViewController, UITextFieldDelegate {

    var cache = SAMCache.shared()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
    
    }

    
   
    @IBAction func loginDidTap() {
    
        if emailTextField.text != "" && (passwordTextField.text?.count)! > 3 {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
                if let error = error {
                    self.alert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
                } else {
                    self.cache?.removeAllObjects()
                    self.dismiss(animated: true, completion: nil);          }
            })
        }
    
    }
    
    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    
    @IBAction func backDidTap(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            
            passwordTextField.becomeFirstResponder()
            
        } else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
            loginDidTap()
        }
        
        return true
    }
    
}
