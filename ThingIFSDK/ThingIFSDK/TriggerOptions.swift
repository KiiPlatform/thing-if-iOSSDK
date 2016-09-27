//
//  TriggerOptions.swift
//  ThingIFSDK
//
//  Created on 2016/09/26.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class TriggerOptions: NSObject, NSCoding {

    public let title: String?

    public let triggerDescription: String?

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

    public func getTitle() -> String? {
        return self.title;
    }

    public func setTitle(title: String?) -> TriggerOptionsBuilder {
        // TODO: implement me.
        return self;
    }

    public func getTriggerDescription() -> String? {
        return self.triggerDescription;
    }

    public func setTriggerDescription(
            triggerDescription: String?)
        -> TriggerOptionsBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func getMetadata() -> Dictionary<String, AnyObject>? {
        return self.metadata;
    }

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
