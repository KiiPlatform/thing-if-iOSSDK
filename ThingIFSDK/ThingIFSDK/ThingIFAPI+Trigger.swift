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
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        if predicate is SchedulePredicate {
            completionHandler(nil, ThingIFError.UNSUPPORTED_ERROR)
            return
        }

        if self.target == nil {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate command
        let commandDict = NSMutableDictionary(dictionary: ["schema": schemaName, "schemaVersion": schemaVersion, "issuer":owner.typedID.toString(), "target":target!.typedID.toString()])
        commandDict.setObject(actions, forKey: "actions")

        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["predicate": predicate.toNSDictionary(), "command": commandDict])
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    trigger = Trigger(triggerID: triggerID, targetID: self.target!.typedID, enabled: true, predicate: predicate, command: Command(commandID: nil, targetID: self.target!.typedID, issuerID: self.owner.typedID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, actionResults: nil, commandState: nil))
                }

                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(trigger, error)
                }
            })
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)
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
        if self.target == nil {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate body
        let requestBodyDict = NSMutableDictionary()

        // generate predicate
            if predicate != nil {
                if predicate is SchedulePredicate {
                    completionHandler(nil, ThingIFError.UNSUPPORTED_ERROR)
                    return
                }
                requestBodyDict.setObject(predicate!.toNSDictionary(), forKey: "predicate")
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
            requestBodyDict.setObject(commandDict, forKey: "command")
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
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)
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
        if self.target == nil {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        var enableString = "enable"
        if !enable {
            enableString = "disable"
        }
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers/\(triggerID)/\(enableString)"

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

        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)

    }

    func _deleteTrigger(
        triggerID:String,
        completionHandler: (Trigger!, ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var trigger:Trigger?
            if error == nil {
                trigger = Trigger()
                trigger!.triggerID = triggerID
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(trigger, error)
            }
        })

        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
    }

    func _listTriggers(
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (triggers:[Trigger]?, paginationKey:String?, error: ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(triggers: nil, paginationKey: nil, error: ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        var requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers"

        if paginationKey != nil && bestEffortLimit != nil{
            requestURL += "?paginattriggersionKey=\(paginationKey!)&&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil {
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
        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
    }

    func _getTrigger(
        triggerID:String,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.TARGET_NOT_AVAILABLE)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target!.typedID.toString())/triggers/\(triggerID)"

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

        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
    }
}