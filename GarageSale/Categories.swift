//
//  Categories.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation

class Categories : UITableViewController {
    
    @IBOutlet weak var BrowseReveal: UIBarButtonItem!
    
    var Categories = [String]()
    
    override func viewDidLoad() {
        
        Categories = ["Appliances", "Arts & Crafts", "Beauty & Personal Care", "Books", "Clothing", "Electronics", "Home & Kitchen", "Movies & TV", "Sports & Outdoors", "Toys & Games", "Video Games", "Other"]
        
        BrowseReveal.target = self.revealViewController()
        BrowseReveal.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        cell.textLabel?.text = Categories[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryDetail") as? CategoryDetail {
            vc.selectedCategory = Categories[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
