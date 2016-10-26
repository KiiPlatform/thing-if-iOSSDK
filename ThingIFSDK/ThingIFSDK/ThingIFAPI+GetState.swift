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
        _ completionHandler: @escaping (Dictionary<String, AnyObject>?,  ThingIFError?)-> Void
        ){
            guard let target = self.target else {
                completionHandler(nil, ThingIFError.target_NOT_AVAILABLE)
                return
            }

            let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/states"
            
            // generate header
            let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
            
            let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
                var states : Dictionary<String, AnyObject>?
                if response != nil {
                    states = Dictionary<String, AnyObject>()
                    response!.enumerateKeysAndObjects(
                      { (key, obj, stop) -> Void in
                          states![key as! String] = obj as AnyObject
                      }
                    )
                }
                DispatchQueue.main.async {
                    completionHandler(states, error)
                }
            })
            
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
    }
    
}
