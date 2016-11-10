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
        _ triggeredCommandForm: TriggeredCommandForm,
        predicate: Predicate,
        options: TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void)
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate command
        let targetID = triggeredCommandForm.targetID ?? target.typedID
        var commandDict = triggeredCommandForm.toDictionary()
        commandDict["issuer"] = owner.typedID.toString()
        if commandDict["target"] == nil {
            commandDict["target"] = targetID.toString()
        }

        // generate body
        var requestBodyDict: Dictionary<String, Any> = [
          "predicate": predicate.toNSDictionary(),
          "command": commandDict,
          "triggersWhat": TriggersWhat.command.rawValue]
        requestBodyDict["title"] = options?.title
        requestBodyDict["description"] = options?.triggerDescription
        requestBodyDict["metadata"] = options?.metadata

        do{
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    let command = Command(
                      commandID: nil,
                      targetID: targetID,
                      issuerID: self.owner.typedID,
                      schemaName: triggeredCommandForm.schemaName,
                      schemaVersion: triggeredCommandForm.schemaVersion,
                      actions: triggeredCommandForm.actions,
                      actionResults: nil,
                      commandState: nil,
                      title: triggeredCommandForm.title,
                      commandDescription: triggeredCommandForm.commandDescription,
                      metadata: triggeredCommandForm.metadata)
                    trigger = Trigger(
                      triggerID: triggerID,
                      targetID: target.typedID,
                      enabled: true,
                      predicate: predicate,
                      command: command,
                      title: options?.title,
                      triggerDescription: options?.triggerDescription,
                      metadata: options?.metadata
                    )
                }

                DispatchQueue.main.async {
                    completionHandler(trigger, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.jsonParseError)
        }
    }
    func _postNewTrigger(
        _ serverCode:ServerCode,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }
        
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        var requestBodyDict: Dictionary<String, Any> = [
          "predicate": predicate.toNSDictionary(),
          "serverCode": serverCode.toNSDictionary(),
          "triggersWhat": TriggersWhat.serverCode.rawValue]
        requestBodyDict["title"] = options?.title
        requestBodyDict["description"] = options?.triggerDescription
        requestBodyDict["metadata"] = options?.metadata
        do{
            let requestBodyData =
              try JSONSerialization.data(
                withJSONObject: requestBodyDict,
                options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    trigger = Trigger(
                      triggerID: triggerID,
                      targetID: target.typedID,
                      enabled: true,
                      predicate: predicate,
                      serverCode: serverCode,
                      title: options?.title,
                      triggerDescription: options?.triggerDescription,
                      metadata: options?.metadata)
                }
                
                DispatchQueue.main.async {
                    completionHandler(trigger, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.jsonParseError)
        }
    }

    func _patchTrigger(
        _ triggerID: String,
        triggeredCommandForm: TriggeredCommandForm? = nil,
        predicate: Predicate? = nil,
        options: TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void)
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        if triggeredCommandForm == nil && predicate == nil && options == nil {
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate body
        var requestBodyDict: Dictionary<String, Any> = [
          "triggersWhat": TriggersWhat.command.rawValue
        ];
        requestBodyDict["title"] = options?.title
        requestBodyDict["description"] = options?.triggerDescription
        requestBodyDict["metadata"] = options?.metadata

        // generate predicate
        if predicate != nil {
            requestBodyDict["predicate"] = predicate!.toNSDictionary()
        }

        // generate command
        if let form = triggeredCommandForm {
            var command = form.toDictionary()
            command["issuer"] = owner.typedID.toString()
            if command["target"] == nil {
                command["target"] = target.typedID.toString()
            }
            requestBodyDict["command"] = command
        }
        do{
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.PATCH,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                if error == nil {
                    self._getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
                        DispatchQueue.main.async {
                            completionHandler(updatedTrigger, error2)
                        }
                    })
                }else{
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.jsonParseError)
        }
    }

    func _patchTrigger(
        _ triggerID:String,
        serverCode:ServerCode?,
        predicate:Predicate?,
        options:TriggerOptions?,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        if serverCode == nil && predicate == nil && options == nil {
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        var requestBodyDict: Dictionary<String, Any> = [
          "triggersWhat" : TriggersWhat.serverCode.rawValue
        ]
        requestBodyDict["predicate"] = predicate?.toNSDictionary()
        requestBodyDict["serverCode"] = serverCode?.toNSDictionary()
        requestBodyDict["title"] = options?.title
        requestBodyDict["description"] = options?.triggerDescription
        requestBodyDict["metadata"] = options?.metadata
        do{
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.PATCH,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                if error == nil {
                    self._getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
                        DispatchQueue.main.async {
                            completionHandler(updatedTrigger, error2)
                        }
                    })
                }else{
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        }catch(_){
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.jsonParseError)
        }
    }
    
    func _enableTrigger(
        _ triggerID:String,
        enable:Bool,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
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
                    DispatchQueue.main.async {
                        completionHandler(updatedTrigger, error2)
                    }
                })
            }else{
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)

    }

    func _deleteTrigger(
        _ triggerID:String,
        completionHandler: @escaping (String, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(triggerID, ThingIFError.targetNotAvailable)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in

            DispatchQueue.main.async {
                completionHandler(triggerID, error)
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
    
    func _listTriggeredServerCodeResults(
        _ triggerID:String,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: @escaping (_ results:[TriggeredServerCodeResult]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
    )
    {
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
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
            DispatchQueue.main.async {
                completionHandler(results, nextPaginationKey, error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    func _listTriggers(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: @escaping (_ triggers:[Trigger]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
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
                        if let trigger = Trigger.triggerWithNSDict(target.typedID, triggerDict: triggerDict as! NSDictionary){
                            triggers!.append(trigger)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler(triggers, nextPaginationKey, error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    func _getTrigger(
        _ triggerID:String,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = buildDefaultRequest(HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in

            var trigger:Trigger?
            if let responseDict = response{
                trigger = Trigger.triggerWithNSDict(target.typedID, triggerDict: responseDict)
            }
            DispatchQueue.main.async {
                completionHandler(trigger, error)
            }
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }
}
