//
//  AndOrClauseViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/28/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

protocol AndOrClauseViewControllerDelegate {

    func saveClause(newClause: Clause)
}

class AndOrClauseViewController: KiiBaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, AndOrClauseViewControllerDelegate, StatusTableViewCellDelegate, IntervalStatusCellDelegate {

    var andOrClause: Clause!
    var delegate: AndOrClauseViewControllerDelegate?

    private var subClauses = [Clause]()

    // 2 columns of picker view
    private var statusToSelect = [String]()
    private var clauseTypeToSelect = [ClauseType]()

    // will be setted each time selecting items from picker
    private var clauseTypeTempSelected: ClauseType?
    private var statusTempSelected: String?

    // the And/OrClause in the list, which is clicked to next AndOrViewController
    private var subAndOrClauseSelected: NSIndexPath?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // init status list from predefined schema to select in picker view
        if schema != nil && statusToSelect.count == 0 {
            self.statusToSelect = schema!.getStatusNames()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // init clause type list from predefined schemaDict to select in picker view
        self.clauseTypeToSelect = ClauseType.getTypesArray()

        // init subClauses, the datas in table view
        if self.andOrClause != nil {
            if andOrClause is AndClause {
                let andClause = andOrClause as! AndClause
                subClauses = andClause.clauses
            }else {
                let orClause = andOrClause as! OrClause
                subClauses = orClause.clauses
            }
        }
    }

    //MARK: - TableView methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subClauses.count + 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < subClauses.count {
            if let clause = subClauses[indexPath.row] as? RangeClause {
                if let clauseType = ClauseType.getClauseType(clause) {
                    if clauseType == ClauseType.LeftOpen || clauseType == ClauseType.RightOpen || clauseType == ClauseType.BothClose || clauseType == ClauseType.BothOpen {
                        return 100
                    }
                }
            }
        }
        return 75
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == subClauses.count { // Cell for Add Clause
            return tableView.dequeueReusableCellWithIdentifier("NewClauseButtonCell", forIndexPath: indexPath)
        }else {
            let clause = subClauses[indexPath.row]
            let clauseDict = clause.toNSDictionary()
            let clauseType = ClauseType.getClauseType(clause)!

            var cell: UITableViewCell!

            if clause is AndClause || clause is OrClause {
                cell = tableView.dequeueReusableCellWithIdentifier("AndOrClauseCell", forIndexPath: indexPath)
                cell.textLabel?.text = "\(clauseType.rawValue) Clause"
            }else {
                let status = ClauseHelper.getStatusFromClause(clause)
                let statusType = schema!.getStatusType(status)!
                // only for int and bool value
                var singleValue: AnyObject?
                var lowerLimitValue: Int?
                var upperLimitValue: Int?

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
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < subClauses.count {
            let clauseSelected = subClauses[indexPath.row]
            if clauseSelected is AndClause || clauseSelected is OrClause{
                let storyBoard = UIStoryboard(name: "Triggers", bundle: nil)
                if let andOrVC = storyBoard.instantiateViewControllerWithIdentifier("AndOrClauseViewController") as? AndOrClauseViewController {
                    andOrVC.andOrClause = clauseSelected
                    andOrVC.delegate = self
                    self.subAndOrClauseSelected = indexPath
                    self.navigationController?.pushViewController(andOrVC, animated: true)
                }
            }
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == subClauses.count {
            return false
        }else {
            return true
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            subClauses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    func showPickerView() {

        let alertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pickerFrame = CGRectMake(17, 52, 270, 100)
        let picker = UIPickerView(frame: pickerFrame)
        picker.showsSelectionIndicator = true
        picker.dataSource = self
        picker.delegate = self
        alertController.view.addSubview(picker)

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

        buttonOk.addTarget(self, action: "selectClauseAndStatus:", forControlEvents: UIControlEvents.TouchDown)

        //add the toolbar to the alert controller
        alertController.view.addSubview(toolView)

        self.presentViewController(alertController, animated: true, completion: nil)

    }

    //MARK: Custom methods
    func selectClauseAndStatus(sender: UIButton) {
        if let clauseTypeSelected = clauseTypeTempSelected {
            var clauseSelected: Clause?
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

            if clauseSelected != nil {
                self.subClauses.append(clauseSelected!)
                self.tableView.reloadData()
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func cancelPicker(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //MARK: Picker delegation methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0{
            return self.clauseTypeToSelect.count+1
        }else {
            return self.statusToSelect.count+1
        }

    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }else {
            if component == 0 {
                return self.clauseTypeToSelect[row-1].rawValue
            }else {
                return self.statusToSelect[row-1]
            }
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            if component == 0 {
                self.clauseTypeTempSelected = clauseTypeToSelect[row-1]
            }else {
                self.statusTempSelected = statusToSelect[row-1]
            }
        }
    }

    //MARK: IBActions methods
    @IBAction func tapSave(sender: AnyObject) {
        if self.delegate != nil {
            if andOrClause is AndClause {
                let newClause = AndClause()
                for subClause in subClauses {
                    newClause.add(subClause)
                }
                delegate!.saveClause(newClause)
            }else {
                let newClause = OrClause()
                for subClause in subClauses {
                    newClause.add(subClause)
                }
                delegate!.saveClause(newClause)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func tapAddClause(sender: AnyObject) {
        self.showPickerView()
    }


    func saveClause(newClause: Clause) {
        if subAndOrClauseSelected != nil {
            subClauses[subAndOrClauseSelected!.row] = newClause
        }
    }

    func setStatus(sender: UITableViewCell, value: AnyObject) {
        let indexPath = self.tableView.indexPathForCell(sender)!
        let clause = subClauses[indexPath.row]
        let status = ClauseHelper.getStatusFromClause(clause)
        if let statusSchema = schema?.getStatusSchema(status) {
            if let newClause = ClauseHelper.getNewClause(clause, singleValue: value, statusSchema: statusSchema) {
                subClauses[indexPath.row] = newClause
            }
        }
    }

    func setIntervalStatus(sender: UITableViewCell, lowerLimitValue: AnyObject, upperLimitValue: AnyObject) {
        let indexPath = self.tableView.indexPathForCell(sender)!
        let clause = subClauses[indexPath.row] as! RangeClause
        let status = ClauseHelper.getStatusFromClause(clause)
        if let statusSchema = schema?.getStatusSchema(status) {
            if let newClause = ClauseHelper.getNewClause(clause, lowerLimitValue: lowerLimitValue, upperLimitValue: upperLimitValue, statusSchema: statusSchema) {
                subClauses[indexPath.row] = newClause
            }
        }

    }

}
