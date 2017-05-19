//
//  GroupedHistoryStatesQuery.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Query to retrieve grouped states of history. */
public struct GroupedHistoryStatesQuery {

    /** Alias of a query. */
    public let alias: String
    /** Time range of a query. */
    public let timeRange: TimeRange
    /** Query clause. */
    public let clause: QueryClause?
    /** Firmware version of a query. */
    public let firmwareVersion: String?

    fileprivate var aggregation: Aggregation? = nil

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

extension GroupedHistoryStatesQuery : ToJsonObject {

    internal mutating func setAggregation(_ aggregation: Aggregation?) {
        self.aggregation = aggregation
    }

    internal func makeJsonObject() -> [String : Any]{

        let timeRangeClause = TimeRangeClauseInQuery(self.timeRange)

        var clause : [String : Any]
        if self.clause != nil {
            clause = AndClauseInQuery(self.clause!, timeRangeClause).makeJsonObject()
        } else {
            clause = timeRangeClause.makeJsonObject()
        }

        var query : [ String: Any ] = ["clause": clause, "grouped": true ]
        if self.aggregation != nil {
            query["aggregations"] = [ self.aggregation!.makeJsonObject() ]
        }

        var json : [String : Any] = [ "query" : query ]
        json["firmwareVersion"] = self.firmwareVersion
        return json
    }
}
