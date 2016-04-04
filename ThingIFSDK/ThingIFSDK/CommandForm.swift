//
//  CommandForm.swift
//  ThingIFSDK
//
//  Created on 2016/04/04.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class CommandForm: NSObject {

    internal let schemaName: String
    internal let schemaVersion: Int
    internal let actions: [Dictionary<String, AnyObject>]

    public var title: String? {
        get {
            return self.title
        }

        set (title){
            // TODO: implement me.
            self.title = title
        }
    }

    public var desc: String? {
        get {
            return self.desc
        }

        set (desc) {
            self.desc = desc
        }
    }

    public var metadata: [Dictionary<String, AnyObject>]? {
        get {
            return self.metadata
        }

        set (metadata) {
            self.metadata = metadata
        }
    }

    public init(schemaName: String,
                schemaVersion: Int,
                actions: [Dictionary<String, AnyObject>])
    {
        // TODO: implement me.
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
    }

}
