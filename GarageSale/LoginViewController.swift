//
//  LoginViewController.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController : UIViewController {
    
    let loginToList = "LoginToList"
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        
        let myColor : UIColor = UIColor( red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0 )
        
        Username.layer.borderWidth = 1
        Password.layer.borderWidth = 1
        Username.layer.borderColor = myColor.cgColor
        Password.layer.borderColor = myColor.cgColor
        
    }
    
    @IBAction func loginDidTouch(_ sender: Any) {
        
        if (Username.text != "" && Password.text != "") {
        
            FIRAuth.auth()!.signIn(withEmail: Username.text!,
                               password: Password.text!, completion: {
                                (user, error) in
                                
                                if error != nil {
                                    self.errorMessage()
                                }
                                
                                FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
                                    if user != nil {
                                        self.performSegue(withIdentifier: self.loginToList, sender: nil)
                                    }
                                }

            })
        
        } else {
            self.errorMessage()
        }

        
    }
    
    func errorMessage() {
        
        let alert = UIAlertController(title: "Oops!", message: "Incorrect Username or Password", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

        Password.text = ""
    }
    
}
