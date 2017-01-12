//
//  PlantCell.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit

class PlantCell: UITableViewCell {

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plantImage.layer.borderWidth = 1
        plantImage.layer.masksToBounds = false
        plantImage.layer.borderColor = UIColor.white.cgColor
        plantImage.layer.cornerRadius = plantImage.frame.height/2
        plantImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
