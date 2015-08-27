//
//  TriggerCommandEditViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

protocol TriggerCommandEditViewControllerDelegate {

    func saveCommands(schemaName: String, schemaVersion: Int, actions: [Dictionary<String, AnyObject>])
}
class TriggerCommandEditViewController: CommandEditViewController {

    public var delegate: TriggerCommandEditViewControllerDelegate?

    @IBAction func tapSaveCommand(sender: AnyObject) {
        // generate actions array
        var actions = [Dictionary<String, AnyObject>]()
        if let actionsItems = sections[2].items {
            for actionItem in actionsItems {
                if let actionCellData = actionItem as? ActionCellData {
                    // action should be like: ["actionName": ["requiredStatus": value] ], where value can be Bool, Int or Double
                    let action: Dictionary<String, AnyObject> = [actionCellData.actionSchemaDict["name"]!: [actionCellData.actionSchemaDict["required"]!: actionCellData.value]]
                    actions.append(action)
                }
            }
        }
        // the defaultd schema and schemaVersion from predefined schem dict
        var schema: String?
        var schemaVersion: Int?

        if let schemaTextField = self.view.viewWithTag(200) as? UITextField {
            schema = schemaTextField.text!
        }
        if let schemaVersionTextFiled = self.view.viewWithTag(201) as? UITextField {
            schemaVersion = Int(schemaVersionTextFiled.text!)!
        }
        if self.delegate != nil {
            delegate?.saveCommands(schema!, schemaVersion: schemaVersion!, actions: actions)
        }

        self.navigationController?.popViewControllerAnimated(true)
    }

}
