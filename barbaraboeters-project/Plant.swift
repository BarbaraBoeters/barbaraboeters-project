//
//  Plant.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 16-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import Foundation
import Firebase

struct Plant {
    
    let key: String
    let name: String
    let info: String
    let uid: String
    let interval: Int
    let ref: FIRDatabaseReference?
    var completed: Bool
    let lastUpdated: Double
    
    init(name: String, uid: String, completed: Bool, info: String, interval: Int, key: String = "", lastUpdated: Double) {
        self.key = key
        self.name = name
        self.info = info
        self.uid = uid
        self.interval = interval
        self.completed = completed
        self.ref = nil
        self.lastUpdated = lastUpdated
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        info = snapshotValue["info"] as! String
        uid = snapshotValue["uid"] as! String
        interval = snapshotValue["interval"] as! Int
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
        lastUpdated = snapshotValue["lastUpdated"] as! Double
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "info": info,
            "uid": uid,
            "interval": interval,
            "completed": completed,
            "lastUpdated": lastUpdated
        ]
    }
}
