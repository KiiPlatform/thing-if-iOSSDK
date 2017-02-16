//
//  GroupedHistoryStates.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Grouped history states. */
open class GroupedHistoryStates: NSObject, NSCoding {

    /** Time range of this states. */
    open let timeRange: TimeRange
    /** Result objects. */
    open let objects: [HistoryState]

    internal init(_ timeRange: TimeRange, objects: [HistoryState]) {
        self.timeRange = timeRange
        self.objects = objects
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "timeRange") as! TimeRange,
          objects: aDecoder.decodeObject(forKey: "objects") as! [HistoryState])
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.timeRange, forKey: "timeRange")
        aCoder.encode(self.objects, forKey: "objects")
    }

}
