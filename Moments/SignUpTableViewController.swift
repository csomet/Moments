//
//  SignUpTableViewController.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 13/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var imagePickerHelper: ImagePickerHelper?
    var profileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true

        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func createNewUserDidTap() {
        
        print(emailTextField.text?.count ?? "")
        
        if  (emailTextField.text?.count)! >= 5
            && (passwordTextField.text?.count)! >= 3
            && (usernameTextField.text?.count)! >= 4
            && (fullNameTextField.text?.count)! >= 5
            &&  profileImage != nil {
            
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let password = passwordTextField.text!
            let email = emailTextField.text!
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else if let firUser = user {
                    
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", profileImage: self.profileImage, follows: [], followedBy: [])
                    
                    newUser.save(completion: { (error) in
                        
                        if error != nil {
                            
                            
                            let saveUserErrorAlert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                            let alertButtonAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            saveUserErrorAlert.addAction(alertButtonAction)
                            self.present(saveUserErrorAlert, animated: true, completion: nil)
                            
                        }else {
                            //log in the user
                            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                
                                if  error != nil {
                                    //report error
                                    
                                    let alertLogin = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                    let alertLoginAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertLogin.addAction(alertLoginAction)
                                    self.present(alertLogin, animated: true, completion: nil)
                                    
                                }else{
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            })
            
        } else {
            
            
            let alertValidation = UIAlertController(title: "Validation", message: "Make sure you introduced required fields.", preferredStyle: .alert)
            let alertValidationAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertValidation.addAction(alertValidationAction)
            self.present(alertValidation, animated: true, completion: nil)
        }
    
    }

    
    
    @IBAction func backDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func changeProfilePicDidTap(_ sender: Any) {
        
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            if textField == fullNameTextField {
                    emailTextField.becomeFirstResponder()
            } else if textField == emailTextField {
                    usernameTextField.becomeFirstResponder()
            }else if textField == usernameTextField {
                    passwordTextField.becomeFirstResponder()
            }else if textField == passwordTextField{
                passwordTextField.resignFirstResponder()
                createNewUserDidTap()
            }
        
        return true
    }
    
    
}
