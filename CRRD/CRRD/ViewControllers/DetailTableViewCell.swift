//
//  DetailTableViewCell.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/10/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var businessCellImage: UIImageView!
    @IBOutlet var businessCellLabelValue: UILabel!
    @IBOutlet var contactCellImage: UIImageView!
    @IBOutlet var contactCellLabelValue: UILabel!
    @IBOutlet var aboutCellImage: UIImageView!
    @IBOutlet var aboutCellLabelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
