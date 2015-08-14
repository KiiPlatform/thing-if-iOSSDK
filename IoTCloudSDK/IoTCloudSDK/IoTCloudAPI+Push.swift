//
//  IoTCloudAPI+Push.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension IoTCloudAPI {
    func _installPush(
        development:Bool = false,
        completionHandler: (String?, IoTCloudError?)-> Void
        )
    {
        func doInstallationRequest() -> Void {
            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/installations"
            
            // genrate body
            let requestBodyDict = NSMutableDictionary()
            let deviceToken = RemoteNotificationCondition.deviceToken
            
            requestBodyDict["installationRegistrationID"] = deviceToken
            requestBodyDict["deviceType"] = "IOS"
            requestBodyDict["development"] = NSNumber(bool: development)
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
            
            requestHeaderDict["Content-type"] = "application/vnd.kii.InstallationCreationRequest+json"
            
            do{
                let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                // do request
                let request = IotRequest(method:.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                    
                    if let installationID = response?["InstallationID"] as? String{
                        self._installationID = installationID
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(self._installationID, error)
                    }
                })
                let onboardRequestOperation = IoTRequestOperation(request: request)
                operationQueue.addOperation(onboardRequestOperation)
                
            }catch( _){
                //TODO: do logging for exception
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(nil, IoTCloudError.JSON_PARSE_ERROR)
                }
            }
        }
        
        let pushAvilabilityCondition = RemoteNotificationCondition(application: UIApplication.sharedApplication())
        let pushNotAvailableCondition = NegatedCondition<RemoteNotificationCondition>(condition: pushAvilabilityCondition)
        
        let errorPushNotAvailableOperation = BlockOperation { () -> Void in
            completionHandler(nil,IoTCloudError.PUSH_NOT_AVAILABLE)
        }
        
        errorPushNotAvailableOperation.addCondition(pushNotAvailableCondition)
        
        self.operationQueue.addOperation(errorPushNotAvailableOperation)
        
        let installPushOperation = BlockOperation { () -> Void in
            doInstallationRequest()
            
        }
        
        installPushOperation.addCondition(pushAvilabilityCondition)
        
        self.operationQueue.addOperation(installPushOperation)
        
    }

    func _uninstallPush(
        installationID:String?,
        completionHandler: (IoTCloudError?)-> Void
        )
    {
        // TODO: implement it.
    }
}