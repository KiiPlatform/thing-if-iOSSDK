//
//  AggregatedResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

open class AggregatedResult<AggregatedValueValue>: NSCoding {

    /** Returned value to be aggregated. */
    open let value: AggregatedValueValue
    /** Time range of an aggregated result. */
    open let timeRange: TimeRange
    /** Aggregated objectes. */
    open let aggregatedObjects: [HistoryState]

    internal init(
      _ value: AggregatedValueValue,
      timeRange: TimeRange,
      aggregatedObjects: [HistoryState])
    {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
