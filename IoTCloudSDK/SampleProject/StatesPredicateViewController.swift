//
//  StatesPredicateViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class StatesPredicateViewController: KiiBaseTableViewController {

    struct SectionStruct {
        let headerTitle: String!
        var items: [Any]!
    }

    public var statePredicate: StatePredicate?

    private var sections = [SectionStruct]()
    private var statusSchemasToSelect = [Dictionary<String, String>]()

    private var triggersWhensToSelect = [TriggersWhen.CONDITION_CHANGED, TriggersWhen.CONDITION_FALSE_TO_TRUE, TriggersWhen.CONDITION_TRUE]


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // init actionSchemasToSelect from predefined schemaDict
        if schemaDict != nil {
            if let statusSchemaDicts = schemaDict!["statusSchema"] as? [Dictionary<String, String>]{
                self.statusSchemasToSelect = statusSchemaDicts
            }
        }

        if self.statePredicate == nil {
            sections.append(SectionStruct(headerTitle: "TriggersWhen", items: [self.triggersWhensToSelect[0].toString()]))
            sections.append(SectionStruct(headerTitle: "Condition", items: [Any]()))
        }else {
            sections.append(SectionStruct(headerTitle: "TriggersWhen", items: [statePredicate!.triggersWhen.toString()]))
            sections.append(SectionStruct(headerTitle: "Condition", items: [statePredicate!.condition.clause]))

        }
    }

    //MARK: - TableView methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            if sections[section].headerTitle == "Codition" {
                return 1
            }else {
                return sections[section].items.count
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

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if sections[indexPath.section].headerTitle == "Condition" {
            return 75
        }else {
            return 44
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]

        if section.headerTitle == "Condition"{

            if section.items.count == 0 {
                 return tableView.dequeueReusableCellWithIdentifier("NewClauseButtonCell", forIndexPath: indexPath)
            }else {
                let clause = self.statePredicate!.condition.clause
                let clauseDict = self.statePredicate!.condition.toNSDictionary()
                let clauseType = clauseDict["type"] as! String
                let clauseField = clauseDict["field"] as! String
                let clauseValue = clauseDict["value"]

                var cell: UITableViewCell!

                if clause is AndClause || clause is OrClause {
                    cell = tableView.dequeueReusableCellWithIdentifier("AndOrClauseCell", forIndexPath: indexPath)
                    cell.textLabel?.text = "\(clauseType) Clause"
                }else {
                    if isBool(clauseField)! { // if data type of required status is bool, then cell will contain switch
                        cell = tableView.dequeueReusableCellWithIdentifier("NewClauseBoolCell", forIndexPath: indexPath)
                        let boolSwitch = cell.viewWithTag(102) as! UISwitch
                        if let boolValue = clauseValue as? Bool {
                            boolSwitch.setOn(boolValue, animated: false)
                        }
                    }else {
                        cell = tableView.dequeueReusableCellWithIdentifier("NewClauseNumberCell", forIndexPath: indexPath)
                        let textField = cell.viewWithTag(103) as! UITextField
                        textField.text = "\(clauseValue)"
                    }
                    let clauseLabel = cell.viewWithTag(100) as! UILabel // 100 is label to show clause type
                    clauseLabel.text = clauseType
                    let requiredStatusLabel = cell.viewWithTag(101) as! UILabel // 101 is label to show name of field
                    requiredStatusLabel.text = clauseField
                }

                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TriggersWhenCell", forIndexPath: indexPath)
            let itemValue = sections[indexPath.section].items[indexPath.row]
            cell.textLabel?.text = "\(itemValue)"
            return cell
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if sections[indexPath.section].headerTitle == "Actions" {
            if indexPath.row < sections[indexPath.section].items.count { // cell for creating new action should not be editable
                return true
            }else{
                return false
            }
        }else {
            return false
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
//            sections[indexPath.section].items.removeAtIndex(indexPath.row)
//            self.cellDeleted = self.tableView.cellForRowAtIndexPath(indexPath)
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }


}
