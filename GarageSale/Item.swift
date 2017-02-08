//
//  Item.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    
    let key : String
    let name : String
    let category : String
    let price : String
    let addedByUser : String
    let chapter : String
    let quality : String
    let description : String
    let ref : FIRDatabaseReference?
    
    init(name: String, category: String, price: String, addedByUser: String, chapter: String, quality: String, description: String, key: String = "") {
        
        self.name = name
        self.category = category
        self.price = price
        self.addedByUser = addedByUser
        self.chapter = chapter
        self.quality = quality
        self.description = description
        self.ref = nil
        self.key = key
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        category = snapshotValue["category"] as! String
        price = snapshotValue["price"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        chapter = snapshotValue["chapter"] as! String
        quality = snapshotValue["quality"] as! String
        description = snapshotValue["description"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "category": category,
            "price": price,
            "addedByUser": addedByUser,
            "chapter": chapter,
            "quality": quality,
            "description": description,
        ]
    }
    
}
