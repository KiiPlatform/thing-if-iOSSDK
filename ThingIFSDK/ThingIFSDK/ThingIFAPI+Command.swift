//
//  ThingIFAPI+Command.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    func _postNewCommand(
        _ schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, Any>],
        title:String? = nil,
        description:String? = nil,
        metadata:Dictionary<String, Any>? = nil,
        completionHandler: @escaping (Command?, ThingIFError?)-> Void
        ) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }   

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        var requestBodyDict: Dictionary<String, Any> =
          [
            "schema": schemaName,
            "schemaVersion": schemaVersion,
            "actions": actions
          ]

        let issuerID = owner.typedID
        requestBodyDict["issuer"] = issuerID.toString()
        requestBodyDict["title"] = title;
        requestBodyDict["description"] = description;
        requestBodyDict["metadata"] = metadata;

        do{
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var command:Command?
                if let commandID = response?["commandID"] as? String{
                    command = Command(commandID: commandID, targetID: self.target!.typedID, issuerID: issuerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, actionResults: nil, commandState: nil)
                }
                DispatchQueue.main.async {
                    completionHandler(command, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
            
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.jsonParseError)
        }
    }

    func _getCommand(
        _ commandID:String,
        completionHandler: @escaping (Command?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands/\(commandID)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            
            var command:Command?
            if let responseDict = response{
                command = Command.commandWithNSDictionary(responseDict)
            }
            DispatchQueue.main.async {
                completionHandler(command, error)
            }
        })
        
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
    
    func _listCommands(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: @escaping ([Command]?, String?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
            return
        }

        var requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/commands"
        if paginationKey != nil && bestEffortLimit != nil{
            requestURL += "?paginationKey=\(paginationKey!)&bestEffortLimit=\(bestEffortLimit!)"
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
            DispatchQueue.main.async {
                completionHandler(commands, nextPaginationKey, error)
            }
        })
        
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
}
