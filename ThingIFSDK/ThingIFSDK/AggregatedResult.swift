//
//  AggregatedResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregated result. */
public struct AggregatedResult<AggregatedValueType> {

    /** Returned value to be aggregated. */
    public let value: AggregatedValueType
    /** Time range of an aggregated result. */
    public let timeRange: TimeRange
    /** Aggregated objectes. */
    public let aggregatedObjects: [HistoryState]

    /** Initialize `AggregatedResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters value: Returned value to be aggregated.
     - Parameters timeRange: Time range of an aggregated result.
     - Parameters aggregatedObjects: Aggregated objectes.
     */
    public init(
      _ value: AggregatedValueType,
      timeRange: TimeRange,
      aggregatedObjects: [HistoryState])
    {
        self.value = value
        self.timeRange = timeRange
        self.aggregatedObjects = aggregatedObjects
    }

}
