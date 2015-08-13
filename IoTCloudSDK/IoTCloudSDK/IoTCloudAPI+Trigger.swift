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
        issuer:TypedID,
        predicate:Predicate,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        // TODO: implement it.
    }

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