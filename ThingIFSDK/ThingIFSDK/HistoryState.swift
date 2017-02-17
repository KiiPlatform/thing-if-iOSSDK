//
//  HistoryState.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** History of state. */
open class HistoryState: NSObject, NSCoding {

    /** State of a target thing. */
    open let state: [String : Any]
    /** Creation time of a state. */
    open let createdAt: Date

    internal init(_ state: [String: Any], createdAt: Date) {
        self.state = state
        self.createdAt = createdAt
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "state") as! [String : Any],
            createdAt: aDecoder.decodeObject(forKey: "createdAt") as! Date)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.state, forKey: "state")
        aCoder.encode(self.createdAt, forKey: "createdAt")
    }

}
