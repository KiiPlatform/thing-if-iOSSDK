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

 - `ThingIFAPI.postNewTrigger(triggeredCommandForm:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(triggerID:triggeredCommandForm:predicate:options:completionHandler:)`
*/
open class TriggerOptions: NSObject, NSCoding {

    /// Title of a command.
    open let title: String?

    /// Description of a trigger.
    open let triggerDescription: String?

    /// Meta data of a trigger.
    open let metadata: Dictionary<String, AnyObject>?

    // MARK: - Initializing TriggerOptions instance.
    /**
    Initializer of TriggerOptions instance.

    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(title: String? = nil,
                triggerDescription: String? = nil,
                metadata: Dictionary<String, AnyObject>? = nil)
    {
        self.title = title
        self.triggerDescription = triggerDescription;
        self.metadata = metadata;
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.triggerDescription,
                forKey: "triggerDescription")
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.triggerDescription =
            aDecoder.decodeObject(forKey: "triggerDescription") as? String
        self.metadata = aDecoder.decodeObject(forKey: "metadata")
                as? Dictionary<String, AnyObject>
    }
}
