//
//  ItemTableViewCell.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 05-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var done: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
