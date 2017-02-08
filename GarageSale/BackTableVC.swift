//
//  BackTableVC.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["Home", "Notifications", "Categories", "My Items"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
}
