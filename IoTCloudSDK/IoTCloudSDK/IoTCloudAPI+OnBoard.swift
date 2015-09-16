//
//  IoTCloudAPI+OnBoard.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
extension IoTCloudAPI {

    func _onboard(
        byVendorThingID: Bool,
        IDString: String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) ->Void {

            if self.target != nil {
                completionHandler(nil, IoTCloudError.ALREADY_ONBOARDED)
                return
            }
            
            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/onboardings"
            
            // genrate body
            let requestBodyDict = NSMutableDictionary(dictionary: ["thingPassword": thingPassword, "owner": owner.ownerID.toString()])
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
            
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
                        target = Target(targetType: TypedID(type: "THING", id: thingID))
                        self._target = target
                    }
                    self.saveToUserDefault()
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(target, error)
                    }
                })
                let onboardRequestOperation = IoTRequestOperation(request: request)
                operationQueue.addOperation(onboardRequestOperation)
                
            }catch(_){
                kiiSevereLog("IoTCloudError.JSON_PARSE_ERROR")
                completionHandler(nil, IoTCloudError.JSON_PARSE_ERROR)
            }
    }

}