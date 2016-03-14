//
//  ThingIFAPI+OnBoard.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
extension ThingIFAPI {

    func _onboard(
        byVendorThingID: Bool,
        IDString: String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        completionHandler: (Target?, ThingIFError?)-> Void
        ) ->Void {

            if self.target != nil {
                completionHandler(nil, ThingIFError.ALREADY_ONBOARDED)
                return
            }
            
            let requestURL = "\(baseURL)/thing-if/apps/\(appID)/onboardings"
            
            // genrate body
            let requestBodyDict = NSMutableDictionary(dictionary: ["thingPassword": thingPassword, "owner": owner.typedID.toString()])
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)"]
            
            if byVendorThingID {
                requestBodyDict.setObject(IDString, forKey: "vendorThingID")
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            }else {
                requestBodyDict.setObject(IDString, forKey: "thingID")
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            }
            
            if thingType != nil {
                requestBodyDict.setObject(thingType!, forKey: "thingType")
            }
            
            if thingProperties != nil {
                requestBodyDict.setObject(thingProperties!, forKey: "thingProperties")
            }
            
            do{
                let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                // do request
                let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                    
                    var target:Target?
                    if let thingID = response?["thingID"] as? String{
                        let accessToken = response?["accessToken"] as? String
                        target = Target(typedID: TypedID(type: "THING", id: thingID), accessToken: accessToken)

                        self._target = target
                    }
                    self.saveToUserDefault()
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(target, error)
                    }
                })
                let operation = IoTRequestOperation(request: request)
                operationQueue.addOperation(operation)
                
            }catch(_){
                kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
                completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
            }
    }

}