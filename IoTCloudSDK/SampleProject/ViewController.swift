//
//  ViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/5/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class ViewController: UIViewController {
    var iotCloudAPI: IoTCloudAPI!
    var schema: Schema!
    var owner: Owner!

    override func viewDidLoad() {
        super.viewDidLoad()
        owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        
        schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)
        
        iotCloudAPI = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).addSchema(schema).build()

//        onBoardWithVendorThingIDByOwner()
//        onBoardWithThingIDByOwner()
//        postCommand()
        
        let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))
        let commandID = "78d75000-3f48-11e5-8581-0a5eb423ea35"
        getCommand(target, commandID: commandID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onBoardWithVendorThingIDByOwner() {
        do{
            let thingProperties = NSDictionary(dictionary: ["key1":"value1", "key2":"value2"])
            
            try iotCloudAPI.onBoard("th.abcd-efgh", thingPassword: "dummyPassword", thingType: "LED", thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    print(target!.targetType.id)
                }else {
                    print(error)
                }
            }
        }catch(let e){
            print(e)
        }

    }

    func onBoardWithThingIDByOwner() {
        do{

            try iotCloudAPI.onBoard("th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", thingPassword: "dummyPassword") { ( target, error) -> Void in
                if error == nil{
                    print(target!.targetType.id)
                }else {
                    print(error)
                }
            }
        }catch(let e){
            print(e)
        }

    }
    
    func postCommand() {
        do{
            let thingID = "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let thingPassword = "dummyPassword"
            try iotCloudAPI.onBoard(thingID, thingPassword: thingPassword, completionHandler: { (target, error) -> Void in
                self.callPostCommand(target!)
            })

        }catch(let e){
            print(e)
        }
    }
    
    func callPostCommand(target:Target) {
        
        do{
            try self.iotCloudAPI.postNewCommand(target, schemaName: self.schema.name, schemaVersion: 2, actions: [["turnPower":["power":"true"]]], issuer: nil, completionHandler: { (command, error) -> Void in
                
                if error == nil {
                    print(command!.commandID)
                    self.getCommand(target, commandID: command!.commandID)
                }else {
                    print(error)
                }
            })
        }catch(let e){
            print(e)
        }
        
    }
    
    func getCommand(target: Target, commandID: String){
        do {
            try self.iotCloudAPI.getCommand(target, commandID: commandID) { (command, error) -> Void in
                if error == nil {
                    print("commandID:\(command!.commandID), state:\(command!.commandState), taregetID:\(command!.targetID.toString()), issurerID:\(command!.issuerID.toString())")
                    for actionResult in  command!.actionResults  {
                        for (key, value) in actionResult {
                            print("\(key):")
                            let valueDict = value as! NSDictionary
                            for (key1, value1) in valueDict {
                                print("\(key1):\(value1)")
                            }
                        }
                    }
                }else {
                    print(error)
                }
            }
        }catch(let e){
            print(e)
        }

    }
    
    
}

