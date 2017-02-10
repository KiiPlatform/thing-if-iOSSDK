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
        self.timeRange = timeRange
        self.objects = objects
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeNSCodingObject(forKey: "timeRange"),
            objects: aDecoder.decodeNSCodingArray(forKey: "objects")!)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encodeNSCodingObject(self.timeRange, forKey: "timeRange")
        aCoder.encodeNSCodingArray(self.objects, forKey: "objects")
    }

}
