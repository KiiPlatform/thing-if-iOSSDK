//
//  StateViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
class StateViewController: UITableViewController {

    @IBAction func tapLogout(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("iotAPI")
        self.tabBarController?.viewDidAppear(true)
    }

}