//
//  AggregatedResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregated result. */
open class AggregatedResult<AggregatedValueType> {

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

}
