//
//  OnBoardViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/24/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class OnBoardViewController: KiiBaseTableViewController {

    @IBOutlet weak var thingTypeTextField: UITextField!
    @IBOutlet weak var vendorThingID: UITextField!
    @IBOutlet weak var thingPassTextField: UITextField!
    @IBOutlet weak var thingIDTextField: UITextField!


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func tapOnboardWithVendorThingID(sender: AnyObject) {
        if let vendorThingID = vendorThingID.text, thingPassword = thingPassTextField.text {
            showActivityView(true)
            self.iotAPI?.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingTypeTextField.text, thingProperties: nil, completionHandler: { (target, error) -> Void in
                if target != nil {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    self.showActivityView(false)
                }else {
                    self.showAlert("Onboard Failed", error: error, completion: { () -> Void in
                        self.showActivityView(false)
                    })
                }
            })
        }
    }
    @IBAction func tapOnBoardWithThingID(sender: AnyObject) {
        if let thingID = thingIDTextField.text, thingPassword = thingPassTextField.text {
            showActivityView(true)
            self.iotAPI?.onboard(thingID, thingPassword: thingPassword, completionHandler: { (target, error) -> Void in
                if target != nil {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    self.showActivityView(false)
                }else {
                    self.showAlert("Onboard Failed", error: error, completion: { () -> Void in
                        self.showActivityView(false)
                    })
                }
            })
        }
    }
}