//
//  ThingIFAPI+Trigger.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    func _postNewTrigger(
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, AnyObject>],
        predicate:Predicate,
        commandTarget: Target?,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        var commandTarget = commandTarget
        if commandTarget == nil {
            commandTarget = target
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate command
        let commandDict = NSMutableDictionary(dictionary: ["schema": schemaName, "schemaVersion": schemaVersion, "issuer":owner.typedID.toString(), "target":commandTarget!.typedID.toString()])
        commandDict.setObject(actions, forKey: "actions")

        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["predicate": predicate.toNSDictionary(), "command": commandDict, "triggersWhat": TriggersWhat.COMMAND.rawValue])
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    trigger = Trigger(triggerID: triggerID, enabled: true, predicate: predicate, command: Command(commandID: nil, targetID: commandTarget!.typedID, issuerID: self.owner.typedID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, actionResults: nil, commandState: nil))
                }

                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(trigger, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
        }
    }
    func _postNewTrigger(
        serverCode:ServerCode,
        predicate:Predicate,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }
        
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["predicate": predicate.toNSDictionary(), "serverCode": serverCode.toNSDictionary(), "triggersWhat": TriggersWhat.SERVER_CODE.rawValue])
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    trigger = Trigger(triggerID: triggerID, enabled: true, predicate: predicate, serverCode: serverCode)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(trigger, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
        }
    }

    func _patchTrigger(
        triggerID:String,
        schemaName:String?,
        schemaVersion:Int?,
        actions:[Dictionary<String, AnyObject>]?,
        predicate:Predicate?,
        completionHandler: (Trigger?, ThingIFError?) -> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate body
        let requestBodyDict = NSMutableDictionary()
        requestBodyDict["triggersWhat"] = TriggersWhat.COMMAND.rawValue

        // generate predicate
        if predicate != nil {
            requestBodyDict["predicate"] = predicate!.toNSDictionary()
        }

        // generate command
        if schemaName != nil || schemaVersion != nil || actions != nil {
            var commandDict: Dictionary<String, AnyObject> = ["issuer":owner.typedID.toString()]
            if schemaName != nil {
                commandDict["schema"] = schemaName!
            }
            if schemaVersion != nil {
                commandDict["schemaVersion"] = schemaVersion!
            }
            if actions != nil {
                commandDict["actions"] = actions
            }
            requestBodyDict["command"] = commandDict
        }
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.PATCH,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                if error == nil {
                    self._getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(updatedTrigger, error2)
                        }
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(nil, error)
                    }
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
        }
    }

    func _patchTrigger(
        triggerID:String,
        serverCode:ServerCode,
        predicate:Predicate?,
        completionHandler: (Trigger?, ThingIFError?) -> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }
        
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        let requestBodyDict = NSMutableDictionary()
        requestBodyDict["triggersWhat"] = TriggersWhat.SERVER_CODE.rawValue
        
        // generate predicate
        if predicate != nil {
            requestBodyDict["predicate"] = predicate!.toNSDictionary()
        }
        requestBodyDict["serverCode"] = serverCode.toNSDictionary()
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.PATCH,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                if error == nil {
                    self._getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(updatedTrigger, error2)
                        }
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(nil, error)
                    }
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
        }
    }
    
    func _enableTrigger(
        triggerID:String,
        enable:Bool,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        var enableString = "enable"
        if !enable {
            enableString = "disable"
        }
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)/\(enableString)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.PUT,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            if error == nil {
                self._getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(updatedTrigger, error2)
                    }
                })
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(nil, error)
                }
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)

    }

    func _deleteTrigger(
        triggerID:String,
        completionHandler: (String, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(triggerID, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in

            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(triggerID, error)
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
    
    func _listTriggeredServerCodeResults(
        triggerID:String,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (results:[TriggeredServerCodeResult]?, paginationKey:String?, error: ThingIFError?)-> Void
    )
    {
        guard let target = self.target else {
            completionHandler(results: nil, paginationKey: nil, error: ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }
        
        var requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)/results/server-code"

        if paginationKey != nil && bestEffortLimit != nil && bestEffortLimit! != 0 {
            requestURL += "?paginationKey=\(paginationKey!)&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil && bestEffortLimit! != 0 {
            requestURL += "?bestEffortLimit=\(bestEffortLimit!)"
        }else if paginationKey != nil {
            requestURL += "?paginationKey=\(paginationKey!)"
        }
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var results: [TriggeredServerCodeResult]?
            var nextPaginationKey: String?
            if let responseDict = response {
                nextPaginationKey = responseDict["nextPaginationKey"] as? String
                if let resultDicts = responseDict["triggerServerCodeResults"] as? NSArray {
                    results = [TriggeredServerCodeResult]()
                    for resultDict in resultDicts {
                        if let result = TriggeredServerCodeResult.resultWithNSDict(resultDict as! NSDictionary){
                            results!.append(result)
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(results: results, paginationKey: nextPaginationKey, error: error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    func _listTriggers(
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (triggers:[Trigger]?, paginationKey:String?, error: ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(triggers: nil, paginationKey: nil, error: ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        var requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"
        
        if paginationKey != nil && bestEffortLimit != nil && bestEffortLimit! != 0{
            requestURL += "?paginationKey=\(paginationKey!)&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil && bestEffortLimit! != 0 {
            requestURL += "?bestEffortLimit=\(bestEffortLimit!)"
        }else if paginationKey != nil {
            requestURL += "?paginationKey=\(paginationKey!)"
        }

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var triggers: [Trigger]?
            var nextPaginationKey: String?
            if let responseDict = response {
                nextPaginationKey = responseDict["nextPaginationKey"] as? String
                if let triggerDicts = responseDict["triggers"] as? NSArray {
                    triggers = [Trigger]()
                    for triggerDict in triggerDicts {
                        if let trigger = Trigger.triggerWithNSDict(triggerDict as! NSDictionary){
                            triggers!.append(trigger)
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(triggers: triggers, paginationKey: nextPaginationKey, error: error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    func _getTrigger(
        triggerID:String,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in

            var trigger:Trigger?
            if let responseDict = response{
                trigger = Trigger.triggerWithNSDict(responseDict)
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(trigger, error)
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
}
