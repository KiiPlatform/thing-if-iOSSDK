//
//  CommandCreatViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class CommandCreateViewController: KiiBaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {


    struct SectionStruct {
        let headerTitle: String!
        var items: [Any]!
    }

    struct ActionCellData {
        let actionSchemaDict: Dictionary<String, String>!
        let value: Any!
    }

    private var sections = [SectionStruct]()
    private var actionsToSelect = [Dictionary<String, String>]()
    private var selectedActionDict: Dictionary<String, String>?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sections.append(SectionStruct(headerTitle: "Schema", items: [schemaDict!["name"]!]))
        sections.append(SectionStruct(headerTitle: "Version", items: [schemaDict!["version"]!]))
        sections.append(SectionStruct(headerTitle: "Actions", items: [AnyObject]()))

        // init actionsToSelect
        if schemaDict != nil {
            if let actionSchemaDict = schemaDict!["actions"] as? [Dictionary<String, String>]{
                self.actionsToSelect = actionSchemaDict
            }
        }
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

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 75
        }else {
            return 44
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if sections[indexPath.section].headerTitle == "Actions"{

            if indexPath.row == sections[indexPath.section].items.count {
                return tableView.dequeueReusableCellWithIdentifier("NewActionItemButtonCell", forIndexPath: indexPath)
            }else{
                let actionsCellData = sections[indexPath.section].items[indexPath.row] as! ActionCellData
                let requiredStatus = actionsCellData.actionSchemaDict["required"]!
                var cell: UITableViewCell!
                if isBool(requiredStatus)! {
                    cell = tableView.dequeueReusableCellWithIdentifier("NewActionItemBoolCell", forIndexPath: indexPath)
                    let boolSwitch = cell.viewWithTag(102) as! UISwitch
                    if let boolValue = actionsCellData.value as? Bool {
                        boolSwitch.setOn(boolValue, animated: false)
                    }
                }else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NewActionItemNumberCell", forIndexPath: indexPath)
                    let textField = cell.viewWithTag(103) as! UITextField
                    textField.text = "\(actionsCellData.value)"
                }
                let actionNameLabel = cell.viewWithTag(100) as! UILabel
                actionNameLabel.text = actionsCellData.actionSchemaDict["name"]!
                let requiredStatusLabel = cell.viewWithTag(101) as! UILabel
                requiredStatusLabel.text = actionsCellData.actionSchemaDict["required"]!

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

        let alertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pickerFrame = CGRectMake(17, 52, 270, 100)
        let picker = UIPickerView(frame: pickerFrame)
        picker.showsSelectionIndicator = true
        picker.dataSource = self
        picker.delegate = self
        alertController.view.addSubview(picker)

        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRectMake(17, 5, 270, 45)
        let toolView: UIView = UIView(frame: toolFrame)

        //add buttons to the view
        let buttonCancelFrame: CGRect = CGRectMake(0, 7, 100, 30) //size & position of the button as placed on the toolView

        //Create the cancel button & set its title
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame)
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal)
        buttonCancel.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        toolView.addSubview(buttonCancel) //add it to the toolView

        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: "cancelSelection:", forControlEvents: UIControlEvents.TouchDown)


        //add buttons to the view
        let buttonOkFrame: CGRect = CGRectMake(170, 7, 100, 30) //size & position of the button as placed on the toolView

        //Create the Select button & set the title
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame)
        buttonOk.setTitle("Select", forState: UIControlState.Normal)
        buttonOk.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        toolView.addSubview(buttonOk) //add to the subview

        buttonOk.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchDown)

        
        //add the toolbar to the alert controller
        alertController.view.addSubview(toolView)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


    func getRequireStatusSchema(status: String) -> Dictionary<String, AnyObject>? {
        if let specifySchema = schemaDict?["statusSchema"]?[status] as? Dictionary<String, AnyObject>{
            return specifySchema
        }else {
            return nil
        }
    }

    func isBool(status: String) -> Bool? {
        if let statusSchemaDict = getRequireStatusSchema(status) {
            if let statusType = statusSchemaDict["type"] {
                if statusType as! String == "boolean" {
                    return true
                }else {
                    return false
                }
            }else {
                return nil
            }
        }else {
            return nil
        }
    }


    func selectAction(sender: UIButton){
        if let selectedActionDict = self.selectedActionDict {
            if let requiredState = selectedActionDict["required"] {
                var newActionCellData: ActionCellData!
                if let isBoolType = isBool(requiredState) {
                    if isBoolType {
                        newActionCellData = ActionCellData(actionSchemaDict: selectedActionDict, value: false)
                    }else{
                        newActionCellData = ActionCellData(actionSchemaDict: selectedActionDict, value: 0)
                    }
                    sections[2].items.append(newActionCellData)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: sections[2].items.count-1, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
                }

            }
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func cancelSelection(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    // returns number of rows in each component..
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actionsToSelect.count+1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        return actionsToSelect[row-1]["name"]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            return
        }
        self.selectedActionDict = actionsToSelect[row-1]
    }


}