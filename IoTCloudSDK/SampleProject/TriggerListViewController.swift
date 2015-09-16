//
//  TriggerListViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/26/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class TriggerListViewController: KiiBaseTableViewController {

    var triggers = [Trigger]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        triggers.removeAll()
        self.tableView.reloadData()
        self.showActivityView(true)
        getTriggers(nil)

    }

    //MARK: Table view delegation methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triggers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TriggerCell", forIndexPath: indexPath)

        let trigger = triggers[indexPath.row]
        cell.textLabel?.text = trigger.triggerID
        if trigger.enabled {
            cell.detailTextLabel?.text = "enabled"
        }else {
            cell.detailTextLabel?.text = "disabled"
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var enableActionTitle: String!
        let trigger = triggers[indexPath.row]
        if trigger.enabled {
            enableActionTitle = "Disable"
        }else {
            enableActionTitle = "Enable"
        }

        let enableAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: enableActionTitle, handler:{action, indexpath in
            if self.iotAPI != nil && self.target != nil {
                self.iotAPI!.enableTrigger(trigger.triggerID, enable: !trigger.enabled, completionHandler: { (trigger, error) -> Void in
                    if error == nil {
                        // update triggers array
                        self.triggers[indexPath.row] = trigger!
                        self.tableView.reloadData()
                    }else {
                        self.showAlert("\(enableActionTitle) Trigger Failed", error: error, completion: nil)
                    }
                })
            }
        });

        enableAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);

        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in

            if self.iotAPI != nil && self.target != nil {
                // request to delete trigger
                self.iotAPI!.deleteTrigger( trigger.triggerID, completionHandler: { (trigger, error) -> Void in
                    if error == nil { // if delete trigger successfully in server, then delete it from table view
                        self.triggers.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    }else{
                        self.showAlert("Delete Trigger Failed", error: error, completion: nil)
                    }
                })
            }
        });
        return [deleteRowAction, enableAction]
    }

    //MARK: IBAction methods
    @IBAction func tapLogout(sender: AnyObject) {
        logout { () -> Void in
            self.tabBarController?.viewDidAppear(true)
        }
    }

    //MARK: Custom methods
    func getTriggers(nextPaginationKey: String?){
        if iotAPI != nil && target != nil {
            showActivityView(true)
            // use default bestEffortLimit
            iotAPI!.listTriggers(nil, paginationKey: nextPaginationKey, completionHandler: { (triggers, paginationKey, error) -> Void in
                self.showActivityView(false)
                if triggers != nil {

                    self.triggers += triggers!

                    // paginationKey is nil, then there is not more triggers, reload table
                    if paginationKey == nil {
                        self.tableView.reloadData()
                        self.showActivityView(false)
                    }else {
                        self.getTriggers(paginationKey)
                    }
                }else {
                    self.showAlert("Get Triggers Failed", error: error, completion: nil)
                }
            })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showExistingTriggerDetail" {
            if let triggerDetailVC = segue.destinationViewController as? TriggerDetailViewController {
                if let selectedCell = sender as? UITableViewCell {
                    if let indexPath = self.tableView.indexPathForCell(selectedCell){
                        let selectedTrigger = self.triggers[indexPath.row]
                        triggerDetailVC.trigger = selectedTrigger
                    }
                }
            }
        }
    }
}
