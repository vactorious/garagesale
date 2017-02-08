//
//  User.swift
//  GarageSale
//
//  Created by Victor Huang on 12/29/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String!
    
    init(authData: FIRUser) {
        let user = FIRAuth.auth()?.currentUser
        uid = (user?.uid)!
        email = user?.email
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
