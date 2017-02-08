//
//  Comment.swift
//  
//
//  Created by Victor Huang on 2/2/17.
//
//

import Foundation
import Firebase

struct Comment {
    
    let key : String
    let name : String
    let comment : String
    let timestamp : String
    
    init(name: String, comment: String, timestamp: String, key: String = "") {
        
        self.name = name
        self.comment = comment
        self.timestamp = timestamp
        self.key = key
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        comment = snapshotValue["comment"] as! String
        timestamp = snapshotValue["timestamp"] as! String

    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "comment": comment,
            "timestamp": timestamp,
        ]
    }
    
}
