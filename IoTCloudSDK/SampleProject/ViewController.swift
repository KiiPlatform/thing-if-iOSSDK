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

    override func viewDidLoad() {
        super.viewDidLoad()
//        onBoardWithVendorThingIDByOwner()
        onBoardWithThingIDByOwner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onBoardWithVendorThingIDByOwner() {

        let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)

        let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).addSchema(schema).build()

        do{
            let thingProperties = NSDictionary(dictionary: ["key1":"value1", "key2":"value2"])
            
            try api.onBoard("th.abcd-efgh", thingPassword: "dummyPassword", thingType: "LED", thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    print(target)
                }else {
                    print(error)
                }
            }
        }catch(let e){
            print(e)
        }

    }

    func onBoardWithThingIDByOwner() {

        let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)

        let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).addSchema(schema).build()

        do{

            try api.onBoard("th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", thingPassword: "dummyPassword") { ( target, error) -> Void in
                if error == nil{
                    print(target)
                }else {
                    print(error)
                }
            }
        }catch(let e){
            print(e)
        }

    }
}

