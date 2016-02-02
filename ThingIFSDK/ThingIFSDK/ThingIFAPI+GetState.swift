//
//  ThingIFAPI+GetState.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {
    func _getState(
        completionHandler: (Dictionary<String, AnyObject>?,  ThingIFError?)-> Void
        ){
            if self.target == nil {
                completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
                return
            }

            let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/states"
            
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
            
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
    }
    
}