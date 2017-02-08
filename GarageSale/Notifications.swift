//
//  Notifications.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import Foundation

class Notifications: UIViewController {

    @IBOutlet weak var notificationReveal: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        notificationReveal.target = self.revealViewController()
        notificationReveal.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
}
