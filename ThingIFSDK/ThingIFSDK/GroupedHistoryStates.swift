//
//  GroupedHistoryStates.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Grouped history states. */
open class GroupedHistoryStates: NSCoding {

    /** Time range of this states. */
    open let timeRange: TimeRange
    /** Result objects. */
    open let objects: [HistoryState]

    internal init(_ timeRange: TimeRange, objects: [HistoryState]) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
