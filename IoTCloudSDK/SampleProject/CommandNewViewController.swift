//
//  CommandNewViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class CommandNewViewController: CommandEditViewController {

    @IBOutlet weak var uploadButton: UIBarButtonItem!

    //MARK: IBActions methods
    @IBAction func tapUpload(sender: AnyObject) {

        if iotAPI != nil && target != nil && schema != nil{
            // disable upload button while uploading
            self.uploadButton.enabled = false

            // generate actions array
            var actions = [Dictionary<String, AnyObject>]()
            if let actionsItems = sections[2].items {
                for actionItem in actionsItems {
                    if let actionCellData = actionItem as? ActionStruct {
                        actions.append(actionCellData.getActionDict())
                    }
                }
            }
            // the defaultd schema and schemaVersion from predefined schem dict
            var schemaName = schema!.name
            var schemaVersion = schema!.version

            if let schemaTextField = self.view.viewWithTag(200) as? UITextField {
                schemaName = schemaTextField.text!
            }
            if let schemaVersionTextFiled = self.view.viewWithTag(201) as? UITextField {
                schemaVersion = Int(schemaVersionTextFiled.text!)!
            }

            // call postNewCommand method
            iotAPI!.postNewCommand(schemaName, schemaVersion: schemaVersion, actions: actions, completionHandler: { (command, error) -> Void in
                if command != nil {
                    self.navigationController?.popViewControllerAnimated(true)
                }else {
                    self.showAlert("Upload Command Failed", error: error, completion: { () -> Void in
                        self.uploadButton.enabled = true
                    })
                }
            })
        }
    }


}
