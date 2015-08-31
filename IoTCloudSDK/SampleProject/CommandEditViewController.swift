//
//  CommandEditViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class CommandEditViewController: KiiBaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate, StatusTableViewCellDelegate {

    @IBOutlet weak var schemaNameTextField: UITextField!
    @IBOutlet weak var schemaVersionTextField: UITextField!

    var commandStruct: CommandStruct?

    struct SectionStruct {
        let headerTitle: String!
        var items: [Any]!
    }

    var sections = [SectionStruct]()
    
    private var actionSchemasToSelect = [String]()
    private var selectedActionName: String?
    private var cellDeleted: UITableViewCell?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // init actionSchemasToSelect from predefined schemaDict
        if schema != nil {
            self.actionSchemasToSelect = schema!.getActionNames()
        }

        if self.commandStruct == nil {
            sections.append(SectionStruct(headerTitle: "Schema", items: [schema!.name]))
            sections.append(SectionStruct(headerTitle: "Version", items: [schema!.version]))
            sections.append(SectionStruct(headerTitle: "Actions", items: [Any]()))
        }else {
            sections.append(SectionStruct(headerTitle: "Schema", items: [commandStruct!.schemaName]))
            sections.append(SectionStruct(headerTitle: "Version", items: [commandStruct!.schemaVersion]))
            var actionItems = [Any]()
            // construct actionsItems
            for actionDict in commandStruct!.actions {
                if actionDict.keys.count > 0 {
                    let actionNameKey = Array(actionDict.keys)[0]
                    if let actionSchema = schema?.getActionSchema(actionNameKey) {
                        if let actionCellData = ActionStruct(actionSchema: actionSchema, actionDict: actionDict) {
                            actionItems.append(actionCellData)
                        }
                    }
                }
            }
            sections.append(SectionStruct(headerTitle: "Actions", items: actionItems))
        }
    }

    //MARK: - TableView methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            if sections[section].headerTitle == "Actions" {
                return sections[section].items.count+1 // the additional one cell for create new action button
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
        if sections[indexPath.section].headerTitle == "Actions" {
            return 75
        }else {
            return 44
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if sections[indexPath.section].headerTitle == "Actions"{

            // last row for button to create new action
            if indexPath.row == sections[indexPath.section].items.count {
                return tableView.dequeueReusableCellWithIdentifier("NewActionItemButtonCell", forIndexPath: indexPath)
            }else{

                let actionsCellData = sections[indexPath.section].items[indexPath.row] as! ActionStruct
                let requiredStatus = actionsCellData.actionSchema.status

                var cell: UITableViewCell!
                if requiredStatus.type == StatusType.BoolType { // if data type of required status is bool, then cell will contain switch
                    let boolTypecell = tableView.dequeueReusableCellWithIdentifier("NewActionItemBoolCell", forIndexPath: indexPath) as! StatusBoolTypeTableViewCell
                    boolTypecell.delegate = self
                    boolTypecell.titleLabel.text = actionsCellData.actionSchema.name
                    boolTypecell.statusNameLabel.text = actionsCellData.actionSchema.status.name
                    boolTypecell.value = actionsCellData.value as? Bool
                    cell = boolTypecell
                }else {
                    let intCell = tableView.dequeueReusableCellWithIdentifier("NewActionItemNumberCell", forIndexPath: indexPath) as! StatusIntTypeTableViewCell
                    intCell.titleLabel.text = actionsCellData.actionSchema.name
                    intCell.statusNameLabel.text = actionsCellData.actionSchema.status.name
                    intCell.value = actionsCellData.value as? Int
                    intCell.minValue = actionsCellData.actionSchema.status.minValue as? Int
                    intCell.maxValue = actionsCellData.actionSchema.status.maxValue as? Int
                    intCell.delegate = self
                    cell = intCell
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
            sections[indexPath.section].items.removeAtIndex(indexPath.row)
            self.cellDeleted = self.tableView.cellForRowAtIndexPath(indexPath)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    //MARK: IBActions methods

    // "Editing Did End" event handler of text field of NewActionNumberCell
    @IBAction func finishEditing(sender: AnyObject) {
        if let textField = sender as? UITextField {
            if let cell = textField.superview?.superview as? UITableViewCell{
                if cell !== cellDeleted {
                    if let selectedIndexPath = self.tableView.indexPathForCell(cell) {
                        var selectedAction = sections[selectedIndexPath.section].items[selectedIndexPath.row] as? ActionStruct
                        if  selectedAction != nil {
                            if let statusType = selectedAction?.actionSchema.status.type{
                                if statusType == StatusType.IntType {
                                    selectedAction!.value = Int(textField.text!)!
                                }else {
                                    selectedAction!.value = Double(textField.text!)!
                                }
                                // update items array
                                sections[selectedIndexPath.section].items[selectedIndexPath.row] = selectedAction!
                            }
                        }
                    }
                }
            }
        }
    }

    // "Value Changed" event handler of switch of NewActionBoolCell
    @IBAction func changeSwitch(sender: AnyObject) {
        if let boolSwitch = sender as? UISwitch {
            if let cell = boolSwitch.superview?.superview as? UITableViewCell{
                if let selectedIndexPath = self.tableView.indexPathForCell(cell) {
                    var selectedAction = sections[selectedIndexPath.section].items[selectedIndexPath.row] as? ActionStruct
                    if  selectedAction != nil {
                        selectedAction!.value = boolSwitch.on

                        // update items array
                        sections[selectedIndexPath.section].items[selectedIndexPath.row] = selectedAction!
                    }
                }
            }
        }
    }

    // event handler of button "Create New Action"
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

    //MARK: Methods to handle picker button

    func selectAction(sender: UIButton){
        if let selectedActionName = self.selectedActionName {
            if let actionSchema = schema?.getActionSchema(selectedActionName) {
                if let statusType = schema!.getStatusType(actionSchema.status.name) {

                    var defaultedValue: AnyObject?
                    switch statusType {
                    case .BoolType:
                        defaultedValue = false
                    case .IntType:
                        defaultedValue = 0
                    case .DoubleType:
                        defaultedValue = 0.0
                    default:
                        break
                    }

                    if defaultedValue != nil {
                        sections[2].items.append(ActionStruct(actionSchema: actionSchema, value: defaultedValue!))
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: sections[2].items.count-1, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func cancelSelection(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //MARK: Picker delegation methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actionSchemasToSelect.count+1
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        return actionSchemasToSelect[row-1]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            return
        }
        self.selectedActionName = actionSchemasToSelect[row-1]
    }

    func setStatus(sender: UITableViewCell, value: AnyObject) {
        if let selectedIndexPath = self.tableView.indexPathForCell(sender) {
            var selectedAction = sections[selectedIndexPath.section].items[selectedIndexPath.row] as? ActionStruct
            if  selectedAction != nil {
                selectedAction!.value = value
                // update items array
                sections[selectedIndexPath.section].items[selectedIndexPath.row] = selectedAction!
            }
        }
    }

}