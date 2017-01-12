//
//  MyGardenViewController.swift
//  barbaraboeters-project
//
//  Created by Barbara Boeters on 12-01-17.
//  Copyright © 2017 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class MyGardenViewController: UIViewController {

    let ref = FIRDatabase.database().reference(withPath: "my-plants")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "plantj2.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "plantj2.png")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
