//
//  HistoryStatesQuery.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Query to retrieve history of states. */
open class HistoryStatesQuery: NSCoding {

    /** Alias to be queried history. */
    open let alias: String
    /** Query clause. */
    open let clause: QueryClause?
    /** firmware version. */
    open let firmwareVersion: String?
    /** Best effor limit to retrieve results. */
    open let bestEffortLimit: Int?
    /** Key to specify next page. */
    open let nextPaginationKey: String?

    // MARK: - Initializing HistoryStatesQuery instance.
    /** Initializer of HistoryStatesQuery

     - Parameter alias: Alias for a query.
     - Parameter clause: Clause to narrow down history states. If nil
       or ommited, all history states are target to be retrived.
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
      clause: QueryClause? = nil,
      firmwareVersion: String? = nil,
      bestEffortLimit: Int? = nil,
      nextPaginationKey: String? = nil)
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
