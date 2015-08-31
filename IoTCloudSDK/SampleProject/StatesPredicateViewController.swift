//
//  StatesPredicateViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

protocol StatesPredicateViewControllerDelegate {

    func saveStatePredicate(newPredicate: StatePredicate)
}

class StatesPredicateViewController: KiiBaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate, StatusTableViewCellDelegate, IntervalStatusCellDelegate, AndOrClauseViewControllerDelegate {

    struct SectionStruct {
        let headerTitle: String!
        var items: [Any]!
    }

    var statePredicate: StatePredicate?
    var delegate: StatesPredicateViewControllerDelegate?

    private var sections = [SectionStruct]()

    private var statusToSelect = [String]()
    private var clauseTypeToSelect = [ClauseType]()
    private var triggersWhensToSelect = [TriggersWhen.CONDITION_CHANGED, TriggersWhen.CONDITION_FALSE_TO_TRUE, TriggersWhen.CONDITION_TRUE]

    private var triggersWhenSelected: TriggersWhen! {
        get {
            var triggersWhen: TriggersWhen?
            if sections[0].items.count > 0 {
                triggersWhen = sections[0].items[0] as? TriggersWhen
            }
            return triggersWhen
        }

        set {
                sections[0].items = [newValue]
            }
    }
    private var triggersWhenTempSelected: TriggersWhen? // it is setted each time when user select item from pickerView, as soon as tapping "set" button of pickerview, it will be assigned to triggersWhenSelected

    private var clauseSelected: Clause! {
        get {
            var clause: Clause?
            if sections[1].items.count > 0 {
                clause = sections[1].items[0] as? Clause
            }
            return clause
        }
        set {
            sections[1].items = [newValue]
        }
    }
    private var clauseTypeTempSelected: ClauseType?
    private var statusTempSelected: String?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // init actionSchemasToSelect from predefined schemaDict
        if schema != nil && statusToSelect.count == 0 {
            self.statusToSelect = schema!.getStatusNames()
        }

    }

    override func viewDidLoad() {
         super.viewDidLoad()

        self.clauseTypeToSelect = ClauseType.getTypesArray()

        if self.statePredicate == nil {
            sections.append(SectionStruct(headerTitle: "TriggersWhen", items: [triggersWhensToSelect[0].toString()]))
            sections.append(SectionStruct(headerTitle: "Condition", items: [Any]()))
            triggersWhenSelected = triggersWhensToSelect[0]

        }else {
            sections.append(SectionStruct(headerTitle: "TriggersWhen", items: [statePredicate!.triggersWhen.toString()]))
            sections.append(SectionStruct(headerTitle: "Condition", items: [statePredicate!.condition.clause]))
            triggersWhenSelected = statePredicate!.triggersWhen
            clauseSelected = self.statePredicate!.condition.clause
        }
    }

    //MARK: - TableView methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            if sections[section].headerTitle == "Condition" {// always is 1, if there is no clause, will show "Add Clause" button
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
            if sections[indexPath.section].items.count > 0 {
                if let clause = sections[indexPath.section].items[indexPath.row] as? RangeClause {
                    if let clauseType = ClauseType.getClauseType(clause) {
                        if clauseType == ClauseType.LeftOpen || clauseType == ClauseType.RightOpen || clauseType == ClauseType.BothClose || clauseType == ClauseType.BothOpen {
                            return 100
                        }
                    }
                }
            }
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
                let clause = section.items[0] as! Clause
                let clauseDict = clause.toNSDictionary()
                let clauseType = ClauseType.getClauseType(clause)!

                var cell: UITableViewCell!

                if clause is AndClause || clause is OrClause {
                    cell = tableView.dequeueReusableCellWithIdentifier("AndOrClauseCell", forIndexPath: indexPath)
                    cell.textLabel?.text = "\(clauseType.rawValue) Clause"
                }else {
                    // only for int and bool value
                    var singleValue: AnyObject?
                    var lowerLimitValue: Int?
                    var upperLimitValue: Int?
                    let status = ClauseHelper.getStatusFromClause(clause)
                    let statusType = schema!.getStatusType(status)!

                    switch clauseType {
                    case .Equals, .NotEquals:
                        if clauseType == ClauseType.Equals{
                            singleValue = clauseDict["value"]
                        }else {
                            singleValue = (clauseDict["clause"] as! Dictionary<String, AnyObject>)["value"]
                        }

                    case .LessThanOrEquals, .LessThan:
                        singleValue = clauseDict["upperLimit"]

                    case .GreaterThan, .GreaterThanOrEquals:
                        singleValue = clauseDict["lowerLimit"]

                    case .LeftOpen, .RightOpen, .BothOpen, .BothClose:
                        upperLimitValue = clauseDict["upperLimit"] as? Int
                        lowerLimitValue = clauseDict["lowerLimit"] as? Int

                    default:
                        break
                    }

                    switch statusType {
                    case StatusType.BoolType:
                        let boolCell = tableView.dequeueReusableCellWithIdentifier("BoolCell", forIndexPath: indexPath) as! StatusBoolTypeTableViewCell
                        boolCell.value = singleValue as? Bool
                        boolCell.titleLabel.text = clauseType.rawValue
                        boolCell.statusNameLabel.text = status
                        boolCell.delegate = self
                        cell = boolCell

                    case StatusType.IntType:

                        if singleValue != nil {
                            let intCell = tableView.dequeueReusableCellWithIdentifier("IntCell", forIndexPath: indexPath) as! StatusIntTypeTableViewCell
                            intCell.statusNameLabel.text = status
                            intCell.titleLabel.text = clauseType.rawValue
                            intCell.value = singleValue as? Int
                            intCell.minValue = schema?.getStatusSchema(status)?.minValue as? Int
                            intCell.maxValue = schema?.getStatusSchema(status)?.maxValue as? Int
                            intCell.delegate = self
                            cell = intCell

                        }
                        if lowerLimitValue != nil && upperLimitValue != nil {
                            let intervalCell = tableView.dequeueReusableCellWithIdentifier("IntervalCell", forIndexPath: indexPath) as! IntervalStatusIntTypeCell
                            intervalCell.titleLabel.text = clauseType.rawValue
                            intervalCell.upperLimitValue = upperLimitValue!
                            intervalCell.lowerLimitValue = lowerLimitValue!
                            intervalCell.minValue = schema?.getStatusSchema(status)?.minValue as? Int
                            intervalCell.maxValue = schema?.getStatusSchema(status)?.maxValue as? Int
                            intervalCell.delegate = self
                            cell = intervalCell
                        }

                    default:
                        break
                    }

                }

                return cell
            }
        }else {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TriggersWhenCell", forIndexPath: indexPath)
            let itemValue = sections[indexPath.section].items[indexPath.row]
            cell.textLabel?.text = "\(itemValue)"
            return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("TriggersWhenPickerCell", forIndexPath: indexPath)
                return cell
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionStruct = sections[indexPath.section]

        if sectionStruct.headerTitle == "TriggersWhen" {
            self.showPickerView("TriggersWhen")
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if sections[indexPath.section].headerTitle == "Condition" {
            if sections[indexPath.section].items.count == 0 {
                return false
            }else{
                return true
            }
        }else {
            return false
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            sections[indexPath.section].items.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }


    func showPickerView(sentBy: String) {

        let alertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pickerFrame = CGRectMake(17, 52, 270, 100)
        let picker = UIPickerView(frame: pickerFrame)
        picker.showsSelectionIndicator = true
        picker.dataSource = self
        picker.delegate = self
        alertController.view.addSubview(picker)

        if sentBy == "TriggersWhen"{
            picker.tag = 1
            if let selectedIndex = self.triggersWhensToSelect.indexOf(triggersWhenSelected) {
                picker.selectRow(selectedIndex+1, inComponent: 0, animated: false)
            }
        }else{
            picker.tag = 2

            if let statusSelected = self.statusTempSelected {
                if let selectedIndex = self.statusToSelect.indexOf(statusSelected) {
                    picker.selectRow(selectedIndex+1, inComponent: 1, animated: false)
                }
            }

            if let clauseTypeSelected = self.clauseTypeTempSelected {
                if let selectedIndex = self.clauseTypeToSelect.indexOf(clauseTypeSelected) {
                    picker.selectRow(selectedIndex+1, inComponent: 0, animated: false)
                }
            }
        }

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
        buttonCancel.addTarget(self, action: "cancelPicker:", forControlEvents: UIControlEvents.TouchDown)


        //add buttons to the view
        let buttonOkFrame: CGRect = CGRectMake(170, 7, 100, 30) //size & position of the button as placed on the toolView

        //Create the Select button & set the title
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame)
        buttonOk.setTitle("Select", forState: UIControlState.Normal)
        buttonOk.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        toolView.addSubview(buttonOk) //add to the subview

        if sentBy == "TriggersWhen" {
            buttonOk.addTarget(self, action: "selectTriggersWhen:", forControlEvents: UIControlEvents.TouchDown)
        }else {
            buttonOk.addTarget(self, action: "selectClauseAndStatus:", forControlEvents: UIControlEvents.TouchDown)
        }


        //add the toolbar to the alert controller
        alertController.view.addSubview(toolView)

        self.presentViewController(alertController, animated: true, completion: nil)

    }

    //MARK: Custom methods
    func selectTriggersWhen(sender: UIButton){
        if triggersWhenTempSelected != nil {
            triggersWhenSelected = triggersWhenTempSelected
            self.tableView.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func selectClauseAndStatus(sender: UIButton) {
        if let clauseTypeSelected = clauseTypeTempSelected {
            if clauseTypeSelected == ClauseType.And {
                clauseSelected = AndClause()
            }else if clauseTypeSelected == ClauseType.Or {
                clauseSelected = OrClause()
            }

            if let statusSelected = statusTempSelected {
                if let initializedClaue = ClauseHelper.getInitializedClause(clauseTypeSelected, statusSchema: schema?.getStatusSchema(statusSelected)) {
                    clauseSelected = initializedClaue
                }
            }
            self.tableView.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func cancelPicker(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //MARK: Picker delegation methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 1
        }else {
            return 2
        }
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.triggersWhensToSelect.count+1
        }else {
            if component == 0{
                return self.clauseTypeToSelect.count+1
            }else {
                return self.statusToSelect.count+1
            }
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }else {
            if pickerView.tag == 1{
                return self.triggersWhensToSelect[row-1].toString()
            }else {
                if component == 0 {
                 return self.clauseTypeToSelect[row-1].rawValue
                }else {
                    return self.statusToSelect[row-1]
                }
            }
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            if pickerView.tag == 1 {
                self.triggersWhenTempSelected = triggersWhensToSelect[row-1]
            }else {
                if component == 0 {
                    self.clauseTypeTempSelected = clauseTypeToSelect[row-1]
                }else {
                    self.statusTempSelected = statusToSelect[row-1]
                }
            }
        }
    }

    //MARK: IBActions methods
    @IBAction func tapSave(sender: AnyObject) {
        if self.delegate != nil {
            if triggersWhenSelected != nil && clauseSelected != nil {
                delegate!.saveStatePredicate(StatePredicate(condition: Condition(clause: clauseSelected!), triggersWhen: triggersWhenSelected!))
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func tapAddClause(sender: AnyObject) {
        self.showPickerView("AddClause")
    }


    func setStatus(sender: UITableViewCell, value: AnyObject) {
        let indexPath = self.tableView.indexPathForCell(sender)!
        var section = sections[indexPath.section]
        let clause = section.items[indexPath.row] as! Clause
        let status = ClauseHelper.getStatusFromClause(clause)
        if let statusSchema = schema?.getStatusSchema(status) {
            if let newClause = ClauseHelper.getNewClause(clause, singleValue: value, statusSchema: statusSchema) {
                section.items[indexPath.row] = newClause
                sections[indexPath.section] = section
            }
        }
    }

    func setIntervalStatus(sender: UITableViewCell, lowerLimitValue: AnyObject, upperLimitValue: AnyObject) {
        let indexPath = self.tableView.indexPathForCell(sender)!
        var section = sections[indexPath.section]
        let clause = section.items[indexPath.row] as! RangeClause
        let status = ClauseHelper.getStatusFromClause(clause)
        if let statusSchema = schema?.getStatusSchema(status) {
            if let newClause = ClauseHelper.getNewClause(clause, lowerLimitValue: lowerLimitValue, upperLimitValue: upperLimitValue, statusSchema: statusSchema) {
                section.items[indexPath.row] = newClause
                sections[indexPath.section] = section
            }
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editAndOrClause" {
            if let destVC = segue.destinationViewController as? AndOrClauseViewController {
                let cell = sender as! UITableViewCell
                let selectedIndexPath = self.tableView.indexPathForCell(cell)!
                let andOrClause = sections[1].items[selectedIndexPath.row] as? Clause
                destVC.andOrClause = andOrClause
                destVC.delegate = self
            }
        }
    }

    func saveClause(newClause: Clause) {
        var section = sections[1]
        section.items = [newClause]
        sections[1] = section
    }

}
