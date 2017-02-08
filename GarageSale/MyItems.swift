//
//  MyItems.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation
import Firebase

class MyItems: UITableViewController {
    
    @IBOutlet weak var MyItemsReveal: UIBarButtonItem!
    
    var items = [Item]()
    var categories = [String]()
    
    override func viewDidLoad() {
        
        MyItemsReveal.target = self.revealViewController()
        MyItemsReveal.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        categories = ["Appliances", "Arts & Crafts", "Beauty & Personal Care", "Books", "Clothing", "Electronics", "Home & Kitchen", "Movies & TV", "Sports & Outdoors", "Toys & Games", "Video Games", "Other"]
        
        for items in categories {
            
            let ref = FIRDatabase.database().reference(withPath: "items").child(items)
            
            ref.observe(.value, with: { (snapshot) in
                
                for items in snapshot.children {
                    
                    let item = Item(snapshot: items as! FIRDataSnapshot)
                    if item.addedByUser == uid {
                        self.items.append(item)
                    }
                    
                }
                
                self.tableView.reloadData()
                
            })
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.category
        
        cell.imageView?.image = UIImage(named: "whitesquare")
        
        let imageRef = FIRStorage.storage().reference().child("items").child(item.name.lowercased())
        
        imageRef.data(withMaxSize: 18752501) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                cell.imageView?.image = image
            }
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetail {
            vc.selectedProduct = selectedCell.textLabel?.text
            vc.selectedCategory = selectedCell.detailTextLabel?.text
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
