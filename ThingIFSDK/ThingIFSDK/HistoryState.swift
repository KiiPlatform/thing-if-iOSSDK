//
//  HistoryState.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

open class HistoryState: NSCoding {

    /** State of a target thing. */
    open let state: [String : Any]
    /** Creation time of a state. */
    open let createdAt: Date

    internal init(_ state: [String: Any], createdAt: Date) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
