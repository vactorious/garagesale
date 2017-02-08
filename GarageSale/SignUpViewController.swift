//
//  SignUpViewController.swift
//  GarageSale
//
//  Created by Victor Huang on 1/2/17.
//  Copyright © 2017 Victor Huang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let ref = FIRDatabase.database().reference(withPath: "names")
    
    override func viewDidLoad() {
        
        let myColor : UIColor = UIColor( red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0 )
        
        nameField.layer.borderWidth = 1
        emailField.layer.borderWidth = 1
        passwordField.layer.borderWidth = 1
        nameField.layer.borderColor = myColor.cgColor
        emailField.layer.borderColor = myColor.cgColor
        passwordField.layer.borderColor = myColor.cgColor
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        picker.allowsEditing = false
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        
        if nameField.text != "" && emailField.text != "" && passwordField.text != "" && imageView.image != nil {
            
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                       password: passwordField.text!) { user, error in
                                        if error != nil {
                                            self.signErrorMessage()
                                        } else {
                                            let childRef = self.ref.child((user?.uid)!)
                                            childRef.setValue(self.nameField.text!)
                                            let tempStorageRef = FIRStorage.storage().reference().child("profilepics")
                                            let storageRef = tempStorageRef.child((user?.uid)!)
                                            if let uploadData = UIImageJPEGRepresentation(self.imageView.image!, 0.01) {
                                                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                                    if error != nil {
                                                        return
                                                    }
                                                })
                                            }
                                            self.dismiss(animated: true, completion: nil)
                                        }
            }            
            
            
        } else {
            signErrorMessage()
        }
        
    }
    
    func signErrorMessage() {
        
        let alert = UIAlertController(title: "Invalid Registration", message: "Make sure to choose a profile picture, and have at least 6 characters in your password!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        passwordField.text = ""
    }
    
}




