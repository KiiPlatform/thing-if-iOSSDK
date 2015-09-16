////
////  ViewController.swift
////  SampleProject
////
////  Created by Yongping on 8/5/15.
////  Copyright © 2015 Kii Corporation. All rights reserved.
////
//
//import UIKit
//import IoTCloudSDK
//
//class ViewController: UIViewController {
//    var iotCloudAPI: IoTCloudAPI!
//    let schema = (thingType: "SmartLight-Demo",
//    name: "SmartLight-Demo", version: 1)
//    var owner: Owner!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
//        
//        iotCloudAPI = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
//            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).build()
//
////        onboardWithVendorThingIDByOwner()
////        onboardWithThingIDByOwner()
////        postCommand()
//        
//        let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))
//        let commandID = "78d75000-3f48-11e5-8581-0a5eb423ea35"
////        getCommand(target, commandID: commandID)
////        patchTrigger(target, t"a3f7c520-455c-11e5-bcf1-0a5eb423ea35"riggerID: "a3f7c520-455c-11e5-bcf1-0a5eb423ea35")
////        self.iotCloudAPI.getTrigger(target, triggerID: "a3f7c520-455c-11e5-bcf1", completionHandler: { (trigger, error) -> Void in
////            if error == nil {
////                self.enaleDisableTrigger(target, trigger: trigger!)
////            }else {
////                print(error)
////            }
////        })
//        listTrigger(target, bestEfforLimit: 2, nextPaginationKey: nil)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func onboardWithVendorThingIDByOwner() {
//
//        let thingProperties = ["key1":"value1", "key2":"value2"]
//
//        iotCloudAPI.onboard("th.abcd-efgh", thingPassword: "dummyPassword", thingType: "LED", thingProperties: thingProperties) { ( target, error) -> Void in
//            if error == nil{
//                print(target!.targetType.id)
//            }else {
//                print(error)
//            }
//        }
//    }
//
//    func onboardWithThingIDByOwner() {
//
//        iotCloudAPI.onboard("th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", thingPassword: "dummyPassword") { ( target, error) -> Void in
//            if error == nil{
//                print(target!.targetType.id)
//            }else {
//                print(error)
//            }
//        }
//    }
//    
//    func postCommand() {
//        let thingID = "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"
//        let thingPassword = "dummyPassword"
//        iotCloudAPI.onboard(thingID, thingPassword: thingPassword, completionHandler: { (target, error) -> Void in
//            self.callPostCommand(target!)
//        })
//    }
//    
//    func callPostCommand(target:Target) {
//        
//
//        self.iotCloudAPI.postNewCommand(target, schemaName: self.schema.name, schemaVersion: 2, actions: [["turnPower":["power":"true"]]], completionHandler: { (command, error) -> Void in
//            
//            if error == nil {
//                print(command!.commandID)
//                self.getCommand(target, commandID: command!.commandID)
//            }else {
//                print(error)
//            }
//        })
//    }
//    
//    func getCommand(target: Target, commandID: String){
//        self.iotCloudAPI.getCommand(target, commandID: commandID) { (command, error) -> Void in
//            if error == nil {
//                print("commandID:\(command!.commandID), state:\(command!.commandState), taregetID:\(command!.targetID.toString()), issurerID:\(command!.issuerID.toString())")
//                for actionResult in  command!.actionResults  {
//                    for (key, value) in actionResult {
//                        print("\(key):")
//                        let valueDict = value as! NSDictionary
//                        for (key1, value1) in valueDict {
//                            print("\(key1):\(value1)")
//                        }
//                    }
//                }
//            }else {
//                print(error)
//            }
//        }
//    }
//
//    func patchTrigger(target: Target, triggerID: String) {
//        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
//        let statement = Equals(field: "color", value: 0)
//        let condition = Condition(statement: statement)
//        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_CHANGED)
//        self.iotCloudAPI.patchTrigger(target, triggerID: triggerID, schemaName: self.schema.name, schemaVersion: self.schema.version, actions: actions, predicate: predicate) { (trigger, error) -> Void in
//            if error == nil {
//                print("triggerID: \(trigger!.triggerID), enable:\(trigger!.enabled)")
//            }else {
//                print(error)
//            }
//        }
//    }
//
//    func enaleDisableTrigger(target: Target, trigger: Trigger) {
//        let disable = !trigger.enabled
//        self.iotCloudAPI.enableTrigger(target, triggerID: trigger.triggerID, enable: disable, completionHandler: { (updatedTrigger, error) -> Void in
//            if error == nil {
//                print("from \(trigger.enabled) to \(updatedTrigger!.enabled)")
//            }
//        })
//
//    }
//
//    func listTrigger(target: Target, bestEfforLimit: Int?, nextPaginationKey: String?) {
//
//        self.iotCloudAPI.listTriggers(target, bestEffortLimit: bestEfforLimit!, paginationKey: nextPaginationKey) { (triggers, paginationKey, error) -> Void in
//            if error == nil {
//                if let triggerArray = triggers {
//                    print("count: \(triggerArray.count)")
//                }
//                if let nextPaginationKey = paginationKey {
//                    print(nextPaginationKey)
//                    self.listTrigger(target, bestEfforLimit: bestEfforLimit!, nextPaginationKey: nextPaginationKey)
//                }
//             }else {
//                print(error)
//            }
//        }
//    }
//
//}
//
