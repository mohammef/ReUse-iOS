//
//  BusinessDetailTableViewCell.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/10/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import UIKit

class BusinessDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
