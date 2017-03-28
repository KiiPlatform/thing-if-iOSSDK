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
        let commandJson: [String : Any]
        do {
            commandJson = try makeCommandJson(triggeredCommandForm)
        } catch let error as ThingIFError {
            completionHandler(nil, error)
            return
        } catch let error {
            kiiVerboseLog(error)
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }

        postNewTrigger(
          [
            "predicate": (predicate as! ToJsonObject).makeJsonObject(),
            "command" : commandJson,
            "triggersWhat" : TriggersWhat.command.rawValue
          ] + ( options?.makeJsonObject() ?? [ : ]),
          completionHandler: completionHandler)
    }

    private func postNewTrigger(
      _ requestBody: [String : Any],
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers",
          requestHeader:
            self.defaultHeader +
            ["Content-Type" : MediaType.mediaTypeJson.rawValue],
          requestBody: requestBody,
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


    /** Post new Trigger to IoT Cloud.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter serverCode: Server code to be executed by the Trigger.
     - Parameter predicate: Predicate of the Command.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: 1st one is an created
       Trigger instance, 2nd one is an ThingIFError instance when
       failed.
     */
    open func postNewTrigger(
        _ serverCode:ServerCode,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        postNewTrigger(
          [
            "predicate": (predicate as! ToJsonObject).makeJsonObject(),
            "serverCode" : serverCode.makeJsonObject(),
            "triggersWhat" : TriggersWhat.serverCode.rawValue
          ] + ( options?.makeJsonObject() ?? [ : ]),
          completionHandler: completionHandler)
    }

    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.

    **Note**: Please onboard first, or provide a target instance by
      calling copyWithTarget. Otherwise,
      KiiCloudError.TARGET_NOT_AVAILABLE will be return in
      completionHandler callback

    `target` property and `TriggeredCommandForm.targetID` must be same
    owner's things.

    - Parameter triggerID: ID of the Trigger to which the patch is applied.
    - Parameter triggeredCommandForm: Modified triggered command form
      to patch trigger.
    - Parameter predicate: Modified Predicate to be applied as patch.
    - Parameter options: Modified optional data for this trigger.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: 1st one is the modified
      Trigger instance, 2nd one is an ThingIFError instance when
      failed.
    */
    open func patchTrigger(
        _ triggerID:String,
        triggeredCommandForm:TriggeredCommandForm? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?) -> Void) -> Void
    {
        var requestBody = options?.makeJsonObject() ?? [ : ]
        do {
            if let form = triggeredCommandForm {
                requestBody["command"] = try makeCommandJson(form)
                requestBody["triggersWhat"] = TriggersWhat.command.rawValue
            }
        } catch let error as ThingIFError{
            completionHandler(nil, error)
            return
        } catch let error {
            kiiVerboseLog(error)
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }
        requestBody["predicate"] =
          (predicate as? ToJsonObject)?.makeJsonObject()

        patchTrigger(triggerID,
                     requestBody: requestBody,
                     completionHandler: completionHandler)
    }

    private func patchTrigger(
      _ triggerID: String,
      requestBody: [String : Any],
      completionHandler: @escaping (Trigger?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        if requestBody.isEmpty {
            completionHandler(nil, ThingIFError.unsupportedError)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .patch,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)",
          requestHeader:
            self.defaultHeader +
            ["Content-Type" : MediaType.mediaTypeJson.rawValue],
          requestBody: requestBody,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in

            if error != nil {
                DispatchQueue.main.async { completionHandler(nil, error) }
            } else {
                self.getTrigger(triggerID) { completionHandler($0, $1) }
            }
        }
    }

    /** Apply patch to a registered Trigger.
     Modify a registered Trigger with the specified patch.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter triggerID: ID of the Trigger to which the patch is applied.
     - Parameter serverCode: Modified ServerCode to be applied as patch.
     - Parameter predicate: Modified Predicate to be applied as patch.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments: 1st one is the
       modified Trigger instance, 2nd one is an ThingIFError instance
       when failed.
     */
    open func patchTrigger(
        _ triggerID:String,
        serverCode:ServerCode? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        var requestBody = options?.makeJsonObject() ?? [ : ]
        if let serverCode = serverCode {
            requestBody["serverCode"] = serverCode.makeJsonObject()
            requestBody["triggersWhat"] = TriggersWhat.serverCode.rawValue
        }
        requestBody["predicate"] =
          (predicate as? ToJsonObject)?.makeJsonObject()

        patchTrigger(triggerID,
                     requestBody: requestBody,
                     completionHandler: completionHandler)
    }

    
    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the enabled/disabled Trigger instance, 2nd one is an ThingIFError instance when failed.
    */
    open func enableTrigger(
        _ triggerID:String,
        enable:Bool,
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
        )
    {
        _enableTrigger(triggerID, enable: enable, completionHandler: completionHandler)
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

    /** Delete a registered Trigger.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter triggerID: ID of the Trigger to be deleted.
     - Parameter completionHandler: A closure to be executed once
     finished. The closure takes 2 arguments: 1st one is the deleted
     TriggerId, 2nd one is an ThingIFError instance when failed.
    */
    open func deleteTrigger(
        _ triggerID: String,
        completionHandler: @escaping (String, ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(triggerID, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .delete,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(triggerID, $0) }) {
            response, error -> Void in

            DispatchQueue.main.async {
                completionHandler(triggerID, error)
            }
        }
    }

    /** Retrieves list of server code results that was executed by the
     specified trigger.

     Results will be listing with order by modified date descending
     (latest first)

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter bestEffortLimit: Limit the maximum number of the
       Results in theResponse. If omitted default limit internally
       defined is applied. Meaning of 'bestEffort' is if specified
       value is greater than default limit, default limit is applied.
     - Parameter triggerID: ID of the Trigger
     - Parameter paginationKey: If there is further page to be
       retrieved, this API returns paginationKey in 2nd
       element. Specifying this value in next call in the argument
       results continue to get the results from the next page.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 3 arguments: 1st one is Array of
       Results instance if found, 2nd one is paginationKey if there is
       further page to be retrieved, and 3rd one is an instance of
       ThingIFError when failed.
     */
    open func listTriggeredServerCodeResults(
        _ triggerID:String,
        bestEffortLimit:Int? = nil,
        paginationKey:String? = nil,
        completionHandler:
          @escaping (
            _ results:[TriggeredServerCodeResult]?,
            _ paginationKey:String?,
            _ error: ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers/\(triggerID)/results/server-code".appendURLQuery(
            ("paginationKey", paginationKey),
            ("bestEffortLimit", bestEffortLimit)),
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, nil, $0) }) {

            response, error -> Void in
            let results: (ListTriggeredServerCodeResult?, ThingIFError?) =
              convertSpecifiedItem(response, error)
            DispatchQueue.main.async {
                completionHandler(
                  results.0?.results,
                  results.0?.nextPaginationKey,
                  results.1)
            }
        }
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
        completionHandler:
          @escaping (_ triggers:[Trigger]?,
                     _ paginationKey:String?,
                     _ error: ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url:  "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/triggers".appendURLQuery(
            ("paginationKey", paginationKey),
            ("bestEffortLimit", bestEffortLimit)),
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, nil, $0) }) {
            response, error -> Void in

            let json: [String : Any]?
            if let response = response {
                // NOTE: Server does not contains target id but
                // Trigger requires it so I add it. We should discuss
                // whether Trigger requires targe id or not
                json = [
                  "serverResponse" : response,
                  "target" : target.typedID.toString()
                ]
            } else {
                json = nil
            }

            let result: (ListTriggersResult?, ThingIFError?) =
              convertSpecifiedItem(json, error)
            DispatchQueue.main.async {
                completionHandler(
                  result.0?.triggers,
                  result.0?.nextPaginationKey,
                  result.1)
            }
        }
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

            let result = convertTrigger(
              response,
              targetID: target.typedID.toString(),
              error: error)
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }

    private func makeCommandJson(
      _ form: TriggeredCommandForm) throws -> [String : Any]
    {
        var retval = form.makeJsonObject()
        retval["issuer"] = self.owner.typedID.toString()
        if retval["target"] == nil {
            guard let target = self.target else {
                throw ThingIFError.targetNotAvailable
            }
            retval["target"] = target.typedID.toString()
        }
        return retval
    }

}

fileprivate func convertTrigger(
  _ response: [String : Any]?,
  targetID: String,
  error: ThingIFError? = nil) -> (Trigger?, ThingIFError?)
{
    let json: [String : Any]?
    if let response = response {
        // NOTE: Server does not contains target id but
        // Trigger requires it so I add it. We should discuss
        // whether Trigger requires targe id or not
        json = ["serverResponse" : response, "target" : targetID]
    } else {
        json = nil
    }

    return convertSpecifiedItem(json, error)
}

fileprivate struct ListTriggersResult: FromJsonObject {

    let triggers: [Trigger]?
    let nextPaginationKey: String?

    init(_ jsonObject: [String : Any]) throws {
        guard let serverResponse =
                jsonObject["serverResponse"] as? [String : Any],
              let targetID = jsonObject["target"] as? String else {
            throw ThingIFError.jsonParseError
        }

        self.nextPaginationKey = serverResponse["nextPaginationKey"] as? String
        guard let triggers =
                serverResponse["triggers"] as? [[String : Any]] else {
            self.triggers = nil
            return
        }

        self.triggers = try triggers.map {
            let result = convertTrigger($0, targetID: targetID)
            if let error = result.1 {
                throw error
            }
            return result.0!
        }
    }

}

fileprivate struct ListTriggeredServerCodeResult: FromJsonObject {
    let results: [TriggeredServerCodeResult]?
    let nextPaginationKey: String?

    init(_ jsonObject: [String : Any]) throws {
        self.nextPaginationKey = jsonObject["nextPaginationKey"] as? String
        guard let results =
                jsonObject["triggerServerCodeResults"] as? [[String : Any]] else
        {
            self.results = nil
            return
        }

        self.results = try results.map { try TriggeredServerCodeResult($0) }
    }
}
