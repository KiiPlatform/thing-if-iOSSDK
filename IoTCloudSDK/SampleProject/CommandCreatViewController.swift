//
//  CommandCreatViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class CommandCreateViewController: KiiBaseTableViewController {

    private var sections = [SectionStruct]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sections.append(SectionStruct(headerTitle: "Schema", items: [schemaDict!["name"]!]))
        sections.append(SectionStruct(headerTitle: "Version", items: [schemaDict!["version"]!]))
        sections.append(SectionStruct(headerTitle: "Actions", items: [AnyObject]()))
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            if sections[section].headerTitle == "Actions" {
                return sections[section].items.count+1
            }else {
                return 1
            }
        }else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < sections.count {
            return sections[section].headerTitle
        }else {
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if sections[indexPath.section].headerTitle == "Actions"{

            if indexPath.row == sections[indexPath.section].items.count {
                return tableView.dequeueReusableCellWithIdentifier("NewActionItemButtonCell", forIndexPath: indexPath)
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("ActionItemCell", forIndexPath: indexPath)
                let action = sections[indexPath.section].items[indexPath.row] as! Dictionary<String, AnyObject>
                if action.keys.count > 0 {
                    let actionKey: String = Array(action.keys)[0]
                    cell.textLabel?.text = actionKey
                    var actionString = ""
                    if let actionDict = action[actionKey] as? Dictionary<String, AnyObject> {
                        for (key, value) in actionDict {
                            actionString = "\(key): \(value) "
                        }
                    }
                    cell.detailTextLabel?.text = actionString
                }
                return cell
            }
        }else if sections[indexPath.section].headerTitle == "Schema"{
            let cell = tableView.dequeueReusableCellWithIdentifier("SchemaNameCell", forIndexPath: indexPath)
            let itemValue = sections[indexPath.section].items[indexPath.row]
            if let textField = cell.viewWithTag(200) as? UITextField {
                textField.text = "\(itemValue)"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SchemaVersionCell", forIndexPath: indexPath)
            let itemValue = sections[indexPath.section].items[indexPath.row]
            if let textField = cell.viewWithTag(201) as? UITextField {
                textField.text = "\(itemValue)"
            }
            return cell
        }
    }
    @IBAction func tapNewAction(sender: AnyObject) {
//        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: sections[2].items.count-1, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}