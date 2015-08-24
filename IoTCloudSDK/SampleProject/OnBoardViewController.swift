//
//  OnBoardViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/24/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class OnBoardViewController: UITableViewController {

    @IBOutlet weak var thingTypeTextField: UITextField!
    @IBOutlet weak var vendorThingID: UITextField!
    @IBOutlet weak var thingPassTextField: UITextField!
    @IBOutlet weak var thingIDTextField: UITextField!

    var iotAPI: IoTCloudAPI!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ownerData = NSUserDefaults.standardUserDefaults().objectForKey("iotAPI") as? NSData {
            if let iotAPI = NSKeyedUnarchiver.unarchiveObjectWithData(ownerData) as? IoTCloudAPI {
                self.iotAPI = iotAPI
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func tapOnboardWithVendorThingID(sender: AnyObject) {
        if let vendorThingID = vendorThingID.text, thingPassword = thingPassTextField.text {
            iotAPI.onBoard(vendorThingID, thingPassword: thingPassword, thingType: thingTypeTextField.text, thingProperties: nil, completionHandler: { (target, error) -> Void in
                if target != nil {
                    self.saveTarget(target!)
                    print("saved target")
                }else {
                    // output error
                    print(error)
                }
            })
        }
    }
    @IBAction func tapOnBoardWithThingID(sender: AnyObject) {
        if let thingID = thingIDTextField.text, thingPassword = thingPassTextField.text {
            iotAPI.onBoard(thingID, thingPassword: thingPassword, completionHandler: { (target, error) -> Void in
                if target != nil {
                    self.saveTarget(target!)
                    print("saved target")
                }else {
                    // output error
                    print(error)
                }
            })
        }

    }

    func saveTarget(target: Target) {
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(target), forKey: "target")
    }
}