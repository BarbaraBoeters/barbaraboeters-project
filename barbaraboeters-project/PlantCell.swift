//
//  PlantCell.swift
//  barbaraboeters-project
//
//  PlantCell in which you edit the cell from MyGardenViewController.
//  It shows the name of the plant, info and interval
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit

class PlantCell: UITableViewCell {

    @IBOutlet weak var plantImage: RoundedImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantInfo: UILabel!
    @IBOutlet weak var plantDaysLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
