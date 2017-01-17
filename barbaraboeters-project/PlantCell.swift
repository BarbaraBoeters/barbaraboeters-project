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

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantInfo: UILabel!
    @IBOutlet weak var plantDaysLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plantImage.layer.borderWidth = 1
        plantImage.layer.masksToBounds = false
        plantImage.layer.borderColor = UIColor.white.cgColor
        plantImage.layer.cornerRadius = plantImage.frame.height/2
        plantImage.clipsToBounds = true
        plantImage.image = UIImage(named: "happyyellowflower.png")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
