//
//  IoTCloudAPI+GetState.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension IoTCloudAPI {
    func _getState(
        completionHandler: (Dictionary<String, AnyObject>?,  IoTCloudError?)-> Void
        ){
            if self.target == nil {
                completionHandler(nil, IoTCloudError.TARGET_NOT_AVAILABLE)
                return
            }

            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target!.targetType.toString())/states"
            
            // generate header
            let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
            
            let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
                var states : Dictionary<String, AnyObject>?
                if response != nil {
                    states = Dictionary<String, AnyObject>()
                    response!.enumerateKeysAndObjectsUsingBlock{ (key, obj, stop) -> Void in
                        states![key as! String] = obj
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(states, error)
                }
            })
            
            let getStateRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(getStateRequestOperation)
    }
    
}