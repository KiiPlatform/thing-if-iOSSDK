//
//  CommandViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

extension CommandState {
    public func toString() -> String {
        switch self {
        case .DELIVERED:
            return "DELIVERED"
        case .DONE:
            return "DONE"
        case .INCOMPLETE:
            return "INCOMPLETE"
        case .SENDING:
            return "SENDING"
        }
    }
}
class CommandViewController: KiiBaseTableViewController {
    struct SectionStruct {
        let headerTitle: String!
        var items: [AnyObject]!
    }

    var command: Command?
    private var sections = [SectionStruct]()

    @IBAction func refreshCommand(sender: AnyObject) {
        if command != nil && iotAPI != nil && target != nil {
            iotAPI!.getCommand(command!.commandID, completionHandler: { (newCommand, error) -> Void in
                if newCommand != nil {
                    self.command = newCommand
                    self.loadSections()
                    self.tableView.reloadData()
                }else{
                    self.showAlert("Refresh Command Failed", error: error, completion: nil)
                }
            })
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if command != nil {
            self.navigationItem.title = command!.commandID
        }
        loadSections()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].items.count
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

        if sections[indexPath.section].headerTitle == "Actions"  || sections[indexPath.section].headerTitle == "ActionResults" {
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
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommandItemCell", forIndexPath: indexPath)
            let item = sections[indexPath.section].items[indexPath.row]
            cell.textLabel?.text = "\(item)"
            return cell
        }
    }

    func loadSections() {
        sections.removeAll()
        if command != nil {
            sections.append(SectionStruct(headerTitle: "Schema", items: [command!.schemaName]))
            sections.append(SectionStruct(headerTitle: "Version", items: [command!.schemaVersion]))
            sections.append(SectionStruct(headerTitle: "Actions", items: command!.actions))
            sections.append(SectionStruct(headerTitle: "ActionResults", items: command!.actionResults))
            sections.append(SectionStruct(headerTitle: "State", items: [command!.commandState.toString()]))
        }else {
            sections.append(SectionStruct(headerTitle: "Schema", items: [schema!.name]))
            sections.append(SectionStruct(headerTitle: "Version", items: [schema!.version]))
            sections.append(SectionStruct(headerTitle: "Actions", items: [AnyObject]()))
            sections.append(SectionStruct(headerTitle: "ActionResults", items: [AnyObject]()))
            sections.append(SectionStruct(headerTitle: "State", items: [AnyObject]()))
        }

    }

}
