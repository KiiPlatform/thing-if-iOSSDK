//
//  IoTCloudAPI+Trigger.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension IoTCloudAPI {

    func _postNewTrigger(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, Any>],
        predicate:Predicate,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target.targetType.toString())/triggers"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate command
        let commandDict = NSMutableDictionary(dictionary: ["schema": schemaName, "schemaVersion": schemaVersion, "issuer":owner.ownerID.toString(), "target":target.targetType.toString()])
        // convert actions to NSArray instance
        let actionsNSDict = NSMutableArray()
        for action in actions {
            actionsNSDict.addObject(action.toNSDictionary())
        }
        commandDict.setObject(actionsNSDict, forKey: "actions")

        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["predicate": predicate.toNSDictionary(), "command": commandDict])
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var trigger: Trigger?
                if let triggerID = response?["triggerID"] as? String{
                    trigger = Trigger(triggerID: triggerID, targetID: target.targetType, enabled: true, predicate: predicate, command: Command(commandID: nil, targetID: target.targetType, issuerID: self.owner.ownerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, actionResults: nil, commandState: nil))
                }

                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(trigger, error)
                }
            })
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)
        }catch(_){
            completionHandler(nil, IoTCloudError.JSON_PARSE_ERROR)
        }    }

    func _patchTrigger(
        target:Target,
        triggerID:String,
        actions:[Dictionary<String, Any>]?,
        predicate:Predicate?,
        completionHandler: (Trigger?, IoTCloudError?)
        )
    {
        // TODO: implement it.
    }

    func _enableTrigger(
        target:Target,
        triggerID:String,
        enable:Bool,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        // TODO: implement it.
    }

    func _deleteTrigger(
        target:Target,
        triggerID:String,
        completionHandler: (Trigger!, IoTCloudError?)-> Void
        )
    {
        // TODO: implement it.
    }

    func _listTriggers(
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (triggers:[Trigger]?, paginationKey:String?, error: IoTCloudError?)-> Void
        )
    {
        // TODO: implement it.
    }
}