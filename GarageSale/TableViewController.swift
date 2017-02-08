//
//  TableViewController.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import UIKit
import Firebase

struct postStruct {
    var image : UIImage!
    var name : String!
}

var heightOfHeader : CGFloat = 44

class TableViewController : UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var homeReveal: UIBarButtonItem!
    
    var arrayOfPosts = [postStruct]()
    var categories = [String]()
    var allItems = [Item]()
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeReveal.target = self.revealViewController()
        homeReveal.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        categories = ["Appliances", "Arts & Crafts", "Beauty & Personal Care", "Books", "Clothing", "Electronics", "Home & Kitchen", "Movies & TV", "Sports & Outdoors", "Toys & Games", "Video Games", "Other"]
        
        for items in categories {
            
            let ref = FIRDatabase.database().reference(withPath: "items").child(items)
            
            ref.observe(.value, with: { (snapshot) in
                
                for items in snapshot.children {
                    
                    let item = Item(snapshot: items as! FIRDataSnapshot)
                    self.allItems.append(item)
                    
                }
                
                self.tableView.reloadData()
                
            })
            
        }
        
        arrayOfPosts = [postStruct.init(image: #imageLiteral(resourceName: "carre_homme"), name: "Carre Homme"), postStruct.init(image: #imageLiteral(resourceName: "carre_homme"), name: "Jared Davidson"), postStruct.init(image: #imageLiteral(resourceName: "carre_homme"), name: "Victor Huang"), postStruct.init(image: #imageLiteral(resourceName: "carre_homme"), name: "Michael Buble")]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        cell?.imageView?.image = #imageLiteral(resourceName: "carre_homme")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerImageView.image = arrayOfPosts[section].image
        headerView.headerLabel.text = arrayOfPosts[section].name
        headerView.priceLabel.text = "$23"
        
        return headerView
    }
    
    @IBAction func searchButton(_ sender: Any) {
    
        let resultsController = UITableViewController(style: .plain)
        let searchController = UISearchController(searchResultsController: resultsController)
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        self.present(searchController, animated: true, completion: nil)
        
    }
    
}
