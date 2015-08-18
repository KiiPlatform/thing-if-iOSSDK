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
        target:Target,
        completionHandler: (Dictionary<String, Any>?,  IoTCloudError?)-> Void
        ){
            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target.targetType.toString())/states"
            
            // generate header
            let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
            
            let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
                var states : Dictionary<String, Any>?
                if response != nil {
                    states = Dictionary<String, Any>()
                    response!.enumerateKeysAndObjectsUsingBlock{ (key, obj, stop) -> Void in
                        states![key as! String] = obj
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(states, error)
                }
            })
            
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)
    }
    
}