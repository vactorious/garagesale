//
//  HeaderView.swift
//  GarageSale
//
//  Created by Victor Huang on 12/28/16.
//  Copyright © 2016 Victor Huang. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
