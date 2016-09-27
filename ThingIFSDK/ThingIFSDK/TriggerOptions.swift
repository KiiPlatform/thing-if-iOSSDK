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

    private init(title: String?,
                 triggerDescription: String?,
                 metadata: Dictionary<String, AnyObject>?)
    {
        self.title = title
        self.triggerDescription = triggerDescription
        self.metadata = metadata
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

/**
Builder of `TriggerOptions`.
*/
public class TriggerOptionsBuilder: NSObject, NSCoding {

    private var title: String?

    private var triggerDescription: String?

    private var metadata: Dictionary<String, AnyObject>?

    public init(title: String?,
                 triggerDescription: String?,
                 metadata: Dictionary<String, AnyObject>?)
    {
        self.title = title
        self.triggerDescription = triggerDescription
        self.metadata = metadata
    }

    /**
    Build `TriggerOptions` instance.

    - returns: `TriggerOptions` instance
    */
    public func build() -> TriggerOptions {
        return TriggerOptions(
                title: self.title,
                triggerDescription: self.triggerDescription,
                metadata: self.metadata)
    }

    /** Getter of title of this trigger.

    - returns: title of this trigger.
    */
    public func getTitle() -> String? {
        return self.title;
    }

    /** Setter of title of this trigger.

    - Parameter title: title, This should be equal or less than 50 characters.
    - returns: this instance to chain.
    */
    public func setTitle(title: String?) -> TriggerOptionsBuilder {
        // TODO: implement me.
        return self;
    }

    /** Getter of description of this trigger.

    - returns: description of this trigger.
    */
    public func getTriggerDescription() -> String? {
        return self.triggerDescription;
    }

    /** Setter of description of this trigger.

    - Parameter description: description, This should be equal or less
      than 200 characters.
    - returns: this instance to chain.
    */
    public func setTriggerDescription(
            triggerDescription: String?)
        -> TriggerOptionsBuilder
    {
        // TODO: implement me.
        return self;
    }

    /** Getter of metadata of this trigger.

    - returns: metadata of this trigger.
    */
    public func getMetadata() -> Dictionary<String, AnyObject>? {
        return self.metadata;
    }

    /** Setter of metadata of this trigger.

    - Parameter metadata: metadata
    - returns: this instance to chain.
    */
    public func setMetadata(
            metadata: Dictionary<String, AnyObject>?)
        -> TriggerOptionsBuilder
    {
        // TODO: implement me.
        return self;
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
