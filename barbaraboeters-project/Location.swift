//
//  Location.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 31-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
