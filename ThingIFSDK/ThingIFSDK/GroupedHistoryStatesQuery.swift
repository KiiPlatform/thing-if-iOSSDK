//
//  GroupedHistoryStatesQuery.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Query to retrieve grouped states of history. */
open class GroupedHistoryStatesQuery {

    /** Alias of a query. */
    open let alias: String
    /** Time range of a query. */
    open let timeRange: TimeRange
    /** Query clause. */
    open let clause: QueryClause?
    /** Firmware version of a query. */
    open let firmwareVersion: String?


    // MARK: - Initializing GroupedHistoryStatesQuery instance.
    /** Initializer of GroupedHistoryStatesQuery

     - Parameter alias: Alias for a query.
     - Parameter timeRange: time range for a query.
     - Parameter clause: Clause to narrow down history states. If nil
       or ommited, all history states are target to be retrived.
     - Parameter firmwareVersion: Firmware version for a query.
     */
    public init(
      _ alias: String,
      timeRange: TimeRange,
      clause: QueryClause? = nil,
      firmwareVersion: String? = nil)
    {
        self.alias = alias
        self.timeRange = timeRange
        self.clause = clause
        self.firmwareVersion = firmwareVersion
    }

}
