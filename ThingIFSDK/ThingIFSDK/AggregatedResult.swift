//
//  AggregatedResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregated result. */
open class AggregatedResult<AggregatedValueType>: NSCoding {

    /** Returned value to be aggregated. */
    open let value: AggregatedValueType
    /** Time range of an aggregated result. */
    open let timeRange: TimeRange
    /** Aggregated objectes. */
    open let aggregatedObjects: [HistoryState]

    internal init(
      _ value: AggregatedValueType,
      timeRange: TimeRange,
      aggregatedObjects: [HistoryState])
    {
        self.value = value
        self.timeRange = timeRange
        self.aggregatedObjects = aggregatedObjects
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "value") as! AggregatedValueType,
          timeRange: aDecoder.decodeNSCodingObject(forKey: "range")!,
          aggregatedObjects: aDecoder.decodeNSCodingArray(forKey: "objects")!)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.value, forKey: "value")
        aCoder.encodeNSCodingObject(self.timeRange, forKey: "range")
        aCoder.encodeNSCodingArray(self.aggregatedObjects, forKey: "objects")
    }

}
