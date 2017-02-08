//
//  CommentCell.swift
//  GarageSale
//
//  Created by Victor Huang on 2/2/17.
//  Copyright © 2017 Victor Huang. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
