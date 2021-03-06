//
//  TriggerOptions.swift
//  ThingIFSDK
//
//  Created on 2016/09/26.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
Options of trigger.

This class contains optional data in order to create and modify
`Trigger` with following methods:

 - `ThingIFAPI.postNewTrigger(_:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(_:triggeredCommandForm:predicate:options:completionHandler:)`
*/
public struct TriggerOptions {

    // MARK: - Properties
    /// Title of a command.
    public let title: String?

    /// Description of a trigger.
    public let triggerDescription: String?

    /// Meta data of a trigger.
    public let metadata: [String : Any]?

    // MARK: - Initializing TriggerOptions instance.
    /**
    Initializer of TriggerOptions instance.

    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(_ title: String? = nil,
                triggerDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.title = title
        self.triggerDescription = triggerDescription;
        self.metadata = metadata;
    }

}

extension TriggerOptions: ToJsonObject {

    internal func makeJsonObject() -> [String : Any] {
        var retval: [String : Any] = [ : ]
        retval["title"] = self.title
        retval["description"] = self.triggerDescription
        retval["metadata"] = self.metadata
        return retval
    }
}
