//
//  ItemDetail.swift
//  GarageSale
//
//  Created by Victor Huang on 1/14/17.
//  Copyright © 2017 Victor Huang. All rights reserved.
//

import Foundation
import Firebase

class ItemDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedProduct : String?
    var selectedCategory : String?
    var posterId : String?
    var arrayofComments = [Comment]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var chapterLabel: UITextView!
    @IBOutlet weak var descLabel: UITextView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayofComments = [Comment.init(name: "ye", comment: "ye", timestamp: "ye")]
        
        titleLabel.text = selectedProduct
        
        let ref = FIRDatabase.database().reference().child("items").child(selectedCategory!).child((selectedProduct?.lowercased())!)
        
        ref.observe(.value, with: { (snapshot) in
            
            let item = Item(snapshot: snapshot)
            self.qualityLabel.text = "Quality: " + item.quality
            self.priceLabel.text = "$" + item.price
            self.chapterLabel.text = "Purchasing this item will support " + item.chapter + " FBLA"
            self.descLabel.text = "Item Description: " + item.description
            self.posterId = item.addedByUser

        })

        let imageRef = FIRStorage.storage().reference().child("items").child((selectedProduct?.lowercased())!)
        
        imageRef.data(withMaxSize: 18752501) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                self.imageView.image = image
            }
        }
        
        let profileImageRef = FIRStorage.storage().reference().child("profilepics").child("gIHu0hXHZ4RdSkd4tpBjpGGbXIA2")
        
        profileImageRef.data(withMaxSize: 18752501) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                self.posterImageView.image = image
            }
        }
        
        let nameRef = FIRDatabase.database().reference().child("names").child("gIHu0hXHZ4RdSkd4tpBjpGGbXIA2")
    
        nameRef.observe(.value, with: { (snapshot) in
            
            let name = snapshot.value
            self.posterName.text = name as! String?
            
        })
        
        self.commentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "comment")

        commentTableView.delegate = self
        commentTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let contentSize = self.descLabel.sizeThatFits(self.descLabel.bounds.size)
        var frame = self.descLabel.frame
        frame.size.height = contentSize.height
        self.descLabel.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.descLabel, attribute: .height, relatedBy: .equal, toItem: self.descLabel, attribute: .width, multiplier: descLabel.bounds.height/descLabel.bounds.width, constant: 1)
        self.descLabel.addConstraint(aspectRatioTextViewConstraint)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CommentCell", owner: self, options: nil)?.first as! CommentCell
        let comment = arrayofComments[indexPath.row]
        cell.commentName.text = comment.name
        cell.comment.text = comment.comment
        cell.commentTime.text = comment.timestamp
        cell.commentImage.image = #imageLiteral(resourceName: "carre_homme")
        return cell
        
    }

}
