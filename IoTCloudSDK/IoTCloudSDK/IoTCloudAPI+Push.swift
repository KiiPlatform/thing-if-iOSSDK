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
        deviceToken:String,
        development:Bool = false,
        completionHandler: (String?, IoTCloudError?)-> Void
        )
    {
        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/installations"
        
        // genrate body
        let requestBodyDict = NSMutableDictionary()
        
        requestBodyDict["installationRegistrationID"] = deviceToken
        requestBodyDict["deviceType"] = "IOS"
        requestBodyDict["development"] = NSNumber(bool: development)
        requestBodyDict["userID"] = self.owner.ownerID.id
        
        // generate header
        var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
        
        requestHeaderDict["Content-type"] = "application/vnd.kii.InstallationCreationRequest+json"
        
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                
                if let installationID = response?["InstallationID"] as? String{
                    self._installationID = installationID
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(self._installationID, error)
                }
            })
            let installPushRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(installPushRequestOperation)
            
        }catch( _){
            //TODO: do logging for exception
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(nil, IoTCloudError.JSON_PARSE_ERROR)
            }
        }

    }

    func _uninstallPush(
        installationID:String?,
        completionHandler: (IoTCloudError?)-> Void
        )
    {
        let idParam = installationID != nil ? installationID : self._installationID
        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/installations/\(idParam!)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
        
        let request = buildDefaultRequest(.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            
            if error == nil{
                self._installationID = nil
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler( error)
            }
        })
        let uninstallPushRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(uninstallPushRequestOperation)

    }
}