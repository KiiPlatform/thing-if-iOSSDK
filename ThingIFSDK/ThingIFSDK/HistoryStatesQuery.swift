//
//  HistoryStatesQuery.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Query to retrieve history of states. */
public struct HistoryStatesQuery {

    /** Alias to be queried history. */
    public let alias: String
    /** Query clause. */
    public let clause: QueryClause
    /** firmware version. */
    public let firmwareVersion: String?
    /** Best effor limit to retrieve results. */
    public let bestEffortLimit: Int?
    /** Key to specify next page. */
    public let nextPaginationKey: String?

    // MARK: - Initializing HistoryStatesQuery instance.
    /** Initializer of HistoryStatesQuery

     - Parameter alias: Alias for a query.
     - Parameter clause: Clause to narrow down history states.
     - Parameter firmwareVersion: Firmware version for a query.
     - Parameter bestEffortLimit: bestEffortLimit: Limit the maximum
       number of results in a response. If omitted, default limitis
       applied. Meaning of 'bestEffort' is if specified value is
       greater than default limit, default limit is applied.
     - Parameter nextPaginationKey: Key to retrieve next page. You can
       get this value as result of query methods.
     */
    public init(
      _ alias: String,
      clause: QueryClause,
      firmwareVersion: String? = nil,
      bestEffortLimit: Int? = nil,
      nextPaginationKey: String? = nil)
    {
        self.alias = alias
        self.clause = clause
        self.firmwareVersion = firmwareVersion
        self.bestEffortLimit = bestEffortLimit
        self.nextPaginationKey = nextPaginationKey
    }

}

extension HistoryStatesQuery : ToJsonObject {

    internal func makeJsonObject() -> [String : Any]{
        var json : [String : Any] = [:]
        if self.firmwareVersion != nil {
            json["firmwareVersion"] = self.firmwareVersion
        }
        if self.bestEffortLimit != nil {
            json["bestEffortLimit"] = self.bestEffortLimit
        }
        if self.nextPaginationKey != nil {
            json["paginationKey"] = self.nextPaginationKey
        }
        json["query"] = ["clause" : (self.clause as? ToJsonObject)?.makeJsonObject()]
        return json
    }
}
