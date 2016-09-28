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

 - `ThingIFAPI.postNewTrigger(form:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(triggerID:form:predicate:options:completionHandler:)`
*/
public class TriggerOptions: NSObject, NSCoding {

    /// Title of a command.
    public let title: String?

    /// Description of a trigger.
    public let triggerDescription: String?

    /// Meta data of a trigger.
    public let metadata: Dictionary<String, AnyObject>?

    // MARK: - Initializing TriggerOptions instance.
    /**
    Initializer of TriggerOptions instance.

    This initializer copies following fields:

    - `Trigger.title`
    - `Trigger.triggerDescription`
    - `Trigger.metadata`

    If you specify optional arguments corresponding to above mentioned
    value, Optional argument values win against the `Trigger` values.

    Obviously, If you do not specify `Trigger` instance as an argument
    of this initializer, Optional values are used.

    - Parameter trigger: source trigger of this TriggerOptions.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(trigger:Trigger? = nil,
                title: String? = nil,
                triggerDescription: String? = nil,
                metadata: Dictionary<String, AnyObject>? = nil)
    {
        if (title != nil) {
            self.title = title
        } else if (trigger != nil) {
            self.title = trigger!.title
        } else {
            self.title = nil
        }

        if (triggerDescription != nil) {
            self.triggerDescription = triggerDescription
        } else if (trigger != nil) {
            self.triggerDescription = trigger!.triggerDescription
        } else {
            self.triggerDescription = nil
        }

        if (metadata != nil) {
            self.metadata = metadata
        } else if (trigger != nil) {
            self.metadata = trigger!.metadata
        } else {
            self.metadata = nil
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.triggerDescription,
                forKey: "triggerDescription")
        aCoder.encodeObject(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.triggerDescription =
            aDecoder.decodeObjectForKey("triggerDescription") as? String
        self.metadata = aDecoder.decodeObjectForKey("metadata")
                as? Dictionary<String, AnyObject>
    }
}
