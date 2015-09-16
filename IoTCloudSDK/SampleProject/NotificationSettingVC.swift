//
//  NotificationSettingVC.swift
//  SampleProject
//
//  Created by Syah Riza on 8/27/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class NotificationSettingVC: UITableViewController {

    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var installationSwitch: UISwitch!
    var savedIoTAPI: IoTCloudAPI?
    override func viewDidLoad() {
        super.viewDidLoad()
        // try to get iotAPI from NSUserDefaults
        do{
            try savedIoTAPI = IoTCloudAPI.loadWithStoredInstance()
        }catch(_){
            // do nothing
        }
    }
    override func viewWillAppear(animated: Bool) {
        let userNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()


        alertSwitch.on = userNotificationSettings!.types.contains(.Alert)

        guard let installationID : String! = self.savedIoTAPI?.installationID else{
            installationSwitch.on = false
            return
        }
        kiiVerboseLog("Push Installation ID :",installationID)
        installationSwitch.on = installationID != nil


    }
    @IBAction func alertDidChange(sender: UISwitch) {

        if sender.on {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        }else{

            let settings = UIUserNotificationSettings(forTypes:.None, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }

    }
        @IBAction func didChangeInstallation(sender: UISwitch) {

        if sender.on {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? NSData {
                savedIoTAPI?.installPush(data.hexString(), development: true, completionHandler: { (_, error) -> Void in
                    if error != nil {
                        self.installationSwitch.on = false
                    }
                })
            }
        }else{
            savedIoTAPI?.uninstallPush(nil, completionHandler: { (error) -> Void in
                if error != nil {
                    self.installationSwitch.on = true
                }
            })
        }
    }
}
