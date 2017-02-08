//
//  PostItem.swift
//  GarageSale
//
//  Created by Victor Huang on 12/29/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import UIKit
import Firebase

class PostItem: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var qualityText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var chapterText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    let user = FIRAuth.auth()?.currentUser?.uid
    
    let ref = FIRDatabase.database().reference(withPath: "items")
    
    var categories = [String]()
    
    var qualities = [String]()
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    @IBAction func categoryChoose(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        
        for items in categories {
            
            let action = UIAlertAction(title: items, style: .default) { action -> Void in
                self.categoryText.text = items
            }
            alert.addAction(action)
            
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func qualityChoose(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Quality", message: nil, preferredStyle: .actionSheet)
        
        for items in qualities {
            
            let action = UIAlertAction(title: items, style: .default) { action -> Void in
                self.qualityText.text = items
            }
            alert.addAction(action)
            
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let myColor : UIColor = UIColor( red: 0, green: 0, blue: 0, alpha: 1.0 )
        
        if textView.text == "Item Description" {
            textView.text = ""
            textView.textColor = myColor
        }
        textView.becomeFirstResponder()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let myColor : UIColor = UIColor( red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0 )

        if textView.text == "" {
            textView.text = "Item Description"
            textView.textColor = myColor
        }
        textView.resignFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor : UIColor = UIColor( red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0 )
        
        descriptionText.layer.borderWidth = 1
        descriptionText.layer.borderColor = myColor.cgColor
        
        titleText.layer.borderWidth = 1
        categoryText.layer.borderWidth = 1
        qualityText.layer.borderWidth = 1
        priceText.layer.borderWidth = 1
        chapterText.layer.borderWidth = 1
        titleText.layer.borderColor = myColor.cgColor
        categoryText.layer.borderColor = myColor.cgColor
        qualityText.layer.borderColor = myColor.cgColor
        priceText.layer.borderColor = myColor.cgColor
        chapterText.layer.borderColor = myColor.cgColor
        
        categories = ["Appliances", "Arts & Crafts", "Beauty & Personal Care", "Books", "Clothing", "Electronics", "Home & Kitchen", "Movies & TV", "Sports & Outdoors", "Toys & Games", "Video Games", "Other"]
        
        qualities = ["Brand New", "Very Good", "Good", "Fair", "Poor", "Very Poor"]
        
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        if (titleText.text != "" && categoryText.text != "" && qualityText.text != "" && priceText.text != "" && chapterText.text != "" && imageView.image != nil) {
        
            guard let tempTitle = titleText.text else { return }
            guard let tempCategory = categoryText.text else { return }
            guard let tempQuality = qualityText.text else { return }
            guard let tempPrice = priceText.text else { return }
            guard let tempChapter = chapterText.text else { return }
            guard let tempDescription = descriptionText.text else { return }
        
            let newItem = Item(name: tempTitle, category: tempCategory, price: tempPrice, addedByUser: user!, chapter: tempChapter, quality: tempQuality, description: tempDescription)

            let categoryRef = self.ref.child(tempCategory)
            
            let newItemRef = categoryRef.child(tempTitle.lowercased())
        
            newItemRef.setValue(newItem.toAnyObject())
        
            dismiss(animated: true, completion: nil)
            
            let storageRef = FIRStorage.storage().reference().child("items").child(titleText.text!.lowercased())
            
            let image = cropToSquare(image: self.imageView.image!)
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        return
                    }
                    
                })
                
            }

            
        } else {
            
            let alert = UIAlertController(title: "Invalid Post", message: "Please fill in all the boxes!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        //https://gist.github.com/licvido/55d12a8eb76a8103c753
        let contextImage: UIImage = UIImage(cgImage: originalImage.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)

        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        
        return image
    }
    
}
