//
//  RoundedImageView.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 18-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeImageRound()
    }
 
    private func makeImageRound() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}
