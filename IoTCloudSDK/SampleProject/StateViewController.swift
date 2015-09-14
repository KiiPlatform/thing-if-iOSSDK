//
//  StateViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
class StateViewController: KiiBaseTableViewController {
    var stateStringsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getState()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateStringsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StateCell", forIndexPath: indexPath)

        cell.textLabel?.text = stateStringsArray[indexPath.row]

        return cell
    }

    func getState() {
        if target != nil && iotAPI != nil {
            showActivityView(true)
            iotAPI!.getState({ (statesDict, error) -> Void in
                self.showActivityView(false)
                if statesDict != nil {
                    self.stateStringsArray.removeAll()
                    for(key, value) in statesDict! {
                        self.stateStringsArray.append("\(key): \(value)")
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }

    @IBAction func tapRefresh(sender: AnyObject) {
        getState()
    }
    @IBAction func tapLogout(sender: AnyObject) {
        logout { () -> Void in
            self.tabBarController?.viewDidAppear(true)
        }
    }
}