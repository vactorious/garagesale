//
//  CategoryDetail.swift
//  GarageSale
//
//  Created by Victor Huang on 1/2/17.
//  Copyright © 2017 Victor Huang. All rights reserved.
//

import UIKit
import Firebase

class CategoryDetail: UITableViewController {
    
    var selectedCategory : String?
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let ref = FIRDatabase.database().reference(withPath: "items").child(selectedCategory!)
        
        ref.observe(.value, with: { (snapshot) in
            
            var newItems: [Item] = []
            
            for items in snapshot.children {
                
                let item = Item(snapshot: items as! FIRDataSnapshot)
                newItems.insert(item, at: 0)

            }
            
            self.items = newItems
            self.tableView.reloadData()
        })

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$" + item.price
        
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
            vc.selectedCategory = selectedCategory
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
