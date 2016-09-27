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

    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement me.
    }

    public required init?(coder aDecoder: NSCoder) {
        // TODO: implement me.
    }
}
