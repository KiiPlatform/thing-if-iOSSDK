//
//  StatesPredicateViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

enum ClauseType: String {
    case And = "And"
    case Or = "Or"
    case Equals = "Equals"
    case NotEquals = "NotEquals"
    case LessThan = "<"
    case GreaterThan = ">"
    case LessThanOrEquals = "<="
    case GreaterThanOrEquals = ">="
    case LeftOpen = "( ]"
    case RightOpen = "[ )"
    case BothOpen = "( )"
    case BothClose = "[ ]"

    static func getTypesArray() -> [ClauseType] {
        return [ClauseType.And,
            ClauseType.Or,
            ClauseType.Equals,
            ClauseType.NotEquals,
            ClauseType.LessThan,
            ClauseType.LessThanOrEquals,
            ClauseType.GreaterThan,
            ClauseType.GreaterThanOrEquals,
            ClauseType.BothOpen,
            ClauseType.BothClose,
            ClauseType.LeftOpen,
            ClauseType.RightOpen
        ]
    }

    static func getClauseType(clause: Clause) -> ClauseType? {
        if clause is AndClause {
            return ClauseType.And
        }else if clause is OrClause {
            return ClauseType.Or
        }else if clause is EqualsClause {
            return ClauseType.Equals
        }else if clause is NotEqualsClause {
            return ClauseType.NotEquals
        } else if clause is RangeClause {
            let nsdict = clause.toNSDictionary()
            if let _ = nsdict["lowerLimit"], _ = nsdict["upperLimit"], lowerIncluded = nsdict["lowerIncluded"] as? Bool, upperIncluded = nsdict["upperIncluded"] as? Bool{
                if lowerIncluded && upperIncluded {
                    return ClauseType.BothClose
                }else if !lowerIncluded && upperIncluded {
                    return ClauseType.LeftOpen
                }else if lowerIncluded && !upperIncluded {
                    return ClauseType.RightOpen
                }else {
                    return ClauseType.BothOpen
                }
            }

            if let _ = nsdict["lowerLimit"], lowerIncluded = nsdict["lowerIncluded"] as? Bool {
                if lowerIncluded {
                    return ClauseType.GreaterThanOrEquals
                }else {
                    return ClauseType.GreaterThan
                }
            }

            if let _ = nsdict["upperLimit"], upperIncluded = nsdict["upperIncluded"] as? Bool{
                if upperIncluded {
                    return ClauseType.LessThanOrEquals
                }else {
                    return ClauseType.LessThan
                }
            }
            return nil
        }else{
            return nil
        }
    }
}

class StatesPredicateViewController: KiiBaseTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    struct SectionStruct {
        let headerTitle: String!
        var items: [Any]!
    }

    public var statePredicate: StatePredicate?

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

    }

    override func viewDidLoad() {
         super.viewDidLoad()
        // init actionSchemasToSelect from predefined schemaDict
        if schemaDict != nil {
            if let statusArray = self.getStatusArray() {
                self.statusToSelect = statusArray
            }

        }
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
                let clauseField = clauseDict["field"] as! String

                var cell: UITableViewCell!

                if clause is AndClause || clause is OrClause {
                    cell = tableView.dequeueReusableCellWithIdentifier("AndOrClauseCell", forIndexPath: indexPath)
                    cell.textLabel?.text = "\(clauseType.rawValue) Clause"
                }else {
                    let statusType = getStatusType(clauseField)!
                    let selectedClauseType = ClauseType.getClauseType(clause)!
                    switch selectedClauseType {
                    case .Equals, .NotEquals:
                        let value = clauseDict["value"]
                        switch statusType {
                        case StatusType.BoolType:
                            cell = tableView.dequeueReusableCellWithIdentifier("NewClauseBoolCell", forIndexPath: indexPath)
                            let textField = cell.viewWithTag(103) as! UITextField
                            textField.text = "\(value!)"

                        case StatusType.IntType, StatusType.DoubleType:
                            cell = tableView.dequeueReusableCellWithIdentifier("NewClauseNumberCell", forIndexPath: indexPath)
                            let textField = cell.viewWithTag(103) as! UITextField
                            textField.text = "\(value!)"
                        default:
                            break
                        }

                    case .LessThanOrEquals, .LessThan:
                        let upperLimit = clauseDict["upperLimit"]
                        cell = tableView.dequeueReusableCellWithIdentifier("NewClauseNumberCell", forIndexPath: indexPath)
                        let textField = cell.viewWithTag(103) as! UITextField
                        textField.text = "\(upperLimit!)"

                    case .GreaterThan, .GreaterThanOrEquals:
                        let lowerLimit = clauseDict["lowerLimit"]
                        cell = tableView.dequeueReusableCellWithIdentifier("NewClauseNumberCell", forIndexPath: indexPath)
                        let textField = cell.viewWithTag(103) as! UITextField
                        textField.text = "\(lowerLimit!)"

                    case .LeftOpen, .RightOpen, .BothOpen, .BothClose:
                        let upperLimit = clauseDict["upperLimit"]
                        let lowerLimit = clauseDict["lowerLimit"]
                        cell = tableView.dequeueReusableCellWithIdentifier("NewIntervalClauseCell", forIndexPath: indexPath)
                        let upperLimitTextField = cell.viewWithTag(103) as! UITextField
                        upperLimitTextField.text = "\(upperLimit!)"

                        let lowerLimitTextField = cell.viewWithTag(102) as! UITextField
                        lowerLimitTextField.text = "\(lowerLimit!)"
                        
                    default:
                        break
                    }

                    let clauseLabel = cell.viewWithTag(100) as! UILabel // 100 is label to show clause type
                    clauseLabel.text = clauseType.rawValue
                    let requiredStatusLabel = cell.viewWithTag(101) as! UILabel // 101 is label to show name of field
                    requiredStatusLabel.text = clauseField
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
//            self.cellDeleted = self.tableView.cellForRowAtIndexPath(indexPath)
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
                if let statusType = getStatusType(statusSelected) {
                    switch clauseTypeSelected {
                    case .Equals:
                        switch statusType {
                        case StatusType.BoolType:
                            clauseSelected = EqualsClause(field: statusSelected, value: false)
                        case StatusType.IntType:
                            clauseSelected = EqualsClause(field: statusSelected, value: 0)
                        case StatusType.StringType:
                            clauseSelected = EqualsClause(field: statusSelected, value: "")
                        default:
                            break
                        }

                    case .NotEquals:
                        switch statusType {
                        case StatusType.BoolType:
                            clauseSelected = NotEqualsClause(field: statusSelected, value: false)
                        case StatusType.IntType:
                            clauseSelected = NotEqualsClause(field: statusSelected, value: 0)
                        case StatusType.StringType:
                            clauseSelected = NotEqualsClause(field: statusSelected, value: "")
                        default:
                            break
                        }

                    case .LessThan, .LessThanOrEquals:

                        let upperIncluded: Bool!
                        if clauseTypeSelected == ClauseType.LessThanOrEquals {
                            upperIncluded = true
                        }else {
                            upperIncluded = false
                        }

                        switch statusType {
                        case StatusType.IntType:
                            clauseSelected = RangeClause(field: statusSelected, upperLimit: 0, upperIncluded: upperIncluded)
                        case StatusType.DoubleType:
                            clauseSelected = RangeClause(field: statusSelected, upperLimit: 0.0, upperIncluded: upperIncluded)
                        default:
                            break
                        }

                    case .GreaterThan:
                        let lowerIncluded: Bool!
                        if clauseTypeSelected == ClauseType.GreaterThanOrEquals {
                            lowerIncluded = true
                        }else {
                            lowerIncluded = false
                        }
                        switch statusType {
                        case StatusType.IntType:
                            clauseSelected = RangeClause(field: statusSelected, lowerLimit: 0, lowerIncluded: lowerIncluded)
                        case StatusType.DoubleType:
                            clauseSelected = RangeClause(field: statusSelected, lowerLimit: 0.0, lowerIncluded: lowerIncluded)
                        default:
                            break
                        }

                    case .LeftOpen, .RightOpen, .BothClose, .BothOpen:
                        let upperIncluded: Bool!
                        if clauseTypeSelected == ClauseType.LeftOpen || clauseTypeSelected == ClauseType.BothClose {
                            upperIncluded = true
                        }else {
                            upperIncluded = false
                        }

                        let lowerIncluded: Bool!
                        if clauseTypeSelected == ClauseType.RightOpen || clauseTypeSelected == ClauseType.BothClose {
                            lowerIncluded = true
                        }else {
                            lowerIncluded = false
                        }

                        switch statusType {
                        case StatusType.IntType:
                            clauseSelected = RangeClause(field: statusSelected, lowerLimit: 0, lowerIncluded: lowerIncluded, upperLimit: 0, upperIncluded: upperIncluded)
                        case StatusType.DoubleType:
                            clauseSelected = RangeClause(field: statusSelected, lowerLimit: 0.0, lowerIncluded: lowerIncluded, upperLimit: 0.0, upperIncluded: upperIncluded)
                        default:
                            break
                        }
                        
                    default:
                        break
                    }
                }
            }
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

    @IBAction func tapAddClause(sender: AnyObject) {
        self.showPickerView("AddClause")
    }


}
