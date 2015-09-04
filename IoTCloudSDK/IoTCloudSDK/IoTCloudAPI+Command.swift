//
//  IoTCloudAPI+Command.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension IoTCloudAPI {

    func _postNewCommand(
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String,AnyObject>],
        completionHandler: (Command?, IoTCloudError?)-> Void
        ) -> Void
    {
        if self.target == nil {
            completionHandler(nil, IoTCloudError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target!.targetType.toString())/commands"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["schema": schemaName, "schemaVersion": schemaVersion])
        requestBodyDict.setObject(actions, forKey: "actions")

        let issuerID = owner.ownerID
        requestBodyDict.setObject(issuerID.toString(), forKey: "issuer")
        
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var command:Command?
                if let commandID = response?["commandID"] as? String{
                    command = Command(commandID: commandID, targetID: self.target!.targetType, issuerID: issuerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, actionResults: nil, commandState: nil)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(command, error)
                }
            })
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)
            
        }catch(_){
            kiiSevereLog("IoTCloudError.JSON_PARSE_ERROR")
            completionHandler(nil, IoTCloudError.JSON_PARSE_ERROR)
        }
    }

    func _getCommand(
        commandID:String,
        completionHandler: (Command?, IoTCloudError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, IoTCloudError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target!.targetType.toString())/commands/\(commandID)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            
            var command:Command?
            if let responseDict = response{
                command = Command.commandWithNSDictionary(responseDict)
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(command, error)
            }
        })
        
        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
    }
    
    func _listCommands(
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: ([Command]?, String?, IoTCloudError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, nil, IoTCloudError.TARGET_NOT_AVAILABLE)
            return
        }

        var requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target!.targetType.toString())/commands"
        if paginationKey != nil && bestEffortLimit != nil{
            requestURL += "?paginationKey=\(paginationKey!)&&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil {
            requestURL += "?bestEffortLimit=\(bestEffortLimit!)"
        }else if paginationKey != nil {
            requestURL += "?paginationKey=\(paginationKey!)"
        }
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var commands = [Command]()
            var nextPaginationKey: String?
            if response != nil {
                if let commandNSDicts = response!["commands"] as? [NSDictionary] {
                    for commandNSDict in commandNSDicts {
                        if let command = Command.commandWithNSDictionary(commandNSDict) {
                            commands.append(command)
                        }
                    }
                }
                nextPaginationKey = response!["nextPaginationKey"] as? String
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(commands, nextPaginationKey, error)
            }
        })
        
        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
    }
}