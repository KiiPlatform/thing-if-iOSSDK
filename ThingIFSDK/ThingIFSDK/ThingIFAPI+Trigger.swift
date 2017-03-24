//
//  ThingIFAPI+Trigger.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    // MARK: - Trigger methods

    /** Post new Trigger to IoT Cloud.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     When thing related to this ThingIFAPI instance meets condition
     described by predicate, A registered command sends to thing
     related to `TriggeredCommandForm.targetID`.

     `target` property and `TriggeredCommandForm.targetID` must be
     same owner's things.

     - Parameter triggeredCommandForm: Triggered command form of
       posting trigger.
     - Parameter predicate: Predicate of this trigger.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: 1st one is an created
       Trigger instance, 2nd one is an ThingIFError instance when
       failed.
    */
    open func postNewTrigger(
        _ triggeredCommandForm:TriggeredCommandForm,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        var commandJson = triggeredCommandForm.makeJsonObject()
        commandJson["issuer"] = owner.typedID.toString()
        if commandJson["target"] == nil {
            commandJson["target"] = target.typedID.toString()
        }

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers",
          requestHeader:
            self.defaultHeader +
            ["Content-Type" : MediaType.mediaTypeJson.rawValue],
          requestBody: [
            "predicate": (predicate as! ToJsonObject).makeJsonObject(),
            "command" : commandJson,
            "triggersWhat" : TriggersWhat.command.rawValue
          ] + ( options?.makeJsonObject() ?? [ : ]),
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in
            if error != nil {
                DispatchQueue.main.async { completionHandler(nil, error) }
            } else {
                self.getTrigger(response!["triggerID"] as! String) {
                    completionHandler($0, $1)
                }
            }
        }
    }

    func _postNewTrigger(
        _ serverCode:ServerCode,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        fatalError("TODO: implement me.")
        /*
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }
        
        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]
        
        // generate body
        var requestBodyDict: Dictionary<String, Any> = [
          "predicate": predicate.makeDictionary(),
          "serverCode": serverCode.makeDictionary(),
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
        */
    }

    func _patchTrigger(
        _ triggerID: String,
        triggeredCommandForm: TriggeredCommandForm? = nil,
        predicate: Predicate? = nil,
        options: TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void)
    {
        fatalError("must be implemented")
        /*
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
            requestBodyDict["predicate"] = predicate!.makeDictionary()
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
        */
    }

    func _patchTrigger(
        _ triggerID:String,
        serverCode:ServerCode?,
        predicate:Predicate?,
        options:TriggerOptions?,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void
        )
    {
        fatalError("TODO: implement me.")
        /*
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
        requestBodyDict["predicate"] = predicate?.makeDictionary()
        requestBodyDict["serverCode"] = serverCode?.makeDictionary()
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
        */
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
                self.getTrigger(triggerID, completionHandler: { (updatedTrigger, error2) -> Void in
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
        fatalError("TODO: Implement me")
        /*
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
        */
    }

    /** List Triggers belongs to the specified Target

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter bestEffortLimit: Limit the maximum number of the
       Triggers in the Response. If omitted default limit internally
       defined is applied. Meaning of 'bestEffort' is if specified
       value is greater than default limit, default limit is applied.
     - Parameter paginationKey: If there is further page to be
       retrieved, this API returns paginationKey in 2nd
       element. Specifying this value in next call in the argument
       results continue to get the results from the next page.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 3 arguments: 1st one is Array of
       Triggers instance if found, 2nd one is paginationKey if there
       is further page to be retrieved, and 3rd one is an instance of
       ThingIFError when failed.
    */
    open func listTriggers(
        _ bestEffortLimit:Int? = nil,
        paginationKey:String? = nil,
        completionHandler: @escaping (_ triggers:[Trigger]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggers(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }

    func _listTriggers(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: @escaping (_ triggers:[Trigger]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        fatalError("TODO: implement me")
        /*
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
        */
    }

    /** Get specified trigger

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter triggerID: ID of the Trigger to obtain.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: an instance of
       Trigger, an instance of ThingIFError when failed.
    */
    open func getTrigger(
      _ triggerID:String,
      completionHandler: @escaping (Trigger?, ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in

            var response = response

            // NOTE: Server does not contains target id but Trigger
            // requires it so I add it. We should discuss whether
            // Trigger requires targe id or not
            response?["target"] = target.typedID.toString()
            let result: (Trigger?, ThingIFError?) =
              convertSpecifiedItem(response, error)
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }
}
