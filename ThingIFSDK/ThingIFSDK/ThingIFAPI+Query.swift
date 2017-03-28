//
//  ThingIFAPI+Query.swift
//  ThingIFSDK
//
//  Created on 2017/03/17.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    // MARK: Qeury state history.

    /** Query history states with trait alias.

     - Parameter query: Instance of `HistoryStatesQuery`.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 3 arguments:
       - 1st one is array of history states. If there is no objects to
         be queried, the array is empty.
       - 2nd one is a pagination key. It represents information to
         retrieve further page. You can use pagination key to retrieve
         next page by setting nextPaginationKey. if there is no
         further page, pagination key is nil.
       - 3rd one is an instance of ThingIFError when failed.
     */
    open func query(
        _ query: HistoryStatesQuery,
        completionHandler: @escaping (
        [HistoryState]?, String?, ThingIFError?) -> Void) -> Void
    {
        if self.target == nil {
            completionHandler(nil, nil, ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
            .post,
            url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states/aliases/\(query.alias)/query",
            requestHeader:
              self.defaultHeader +
              [
                "Content-Type" : MediaType.mediaTypeTraitStateQueryRequest.rawValue
              ],
            requestBody: query.makeJsonObject(),
            failureBeforeExecutionHandler: { completionHandler(nil, nil, $0) }) {
                response, error in

                let result = convertResponse(response, error) {
                    response, error throws ->
                    (([HistoryState]?, String?)?, ThingIFError?) in
                    if let error = error {
                        switch error {
                        case .errorResponse(let errorResponse) where
                            errorResponse.httpStatusCode == 409 &&
                                errorResponse.errorCode ==
                            "STATE_HISTORY_NOT_AVAILABLE":
                            return (([], nil), nil)
                        default:
                            return (nil, error)
                        }
                    }
                    return (
                        (
                            try (response!["results"] as! [[String : Any]]).map {
                                try HistoryState($0)
                            },
                            response!["nextPaginationKey"] as? String
                        ),
                        nil)
                }
                DispatchQueue.main.async { completionHandler(result.0?.0, result.0?.1, result.1) }
        }
    }

    /** Aggregate history states

     `AggregatedValueType` represents type of calcuated value with
     `Aggregation.FunctionType`.

     - If the function is `Aggregation.FunctionType.max`,
       `Aggregation.FunctionType.min` or
       `Aggregation.FunctionType.sum`, the type may be same as type of
       field represented by `Aggregation.FieldType`.
     - If the function is `Aggregation.FunctionType.mean`, the type
       may be `Double`.
     - If the function is `Aggregation.FunctionType.count`, the type
       must be `Int`.

     - Parameter query: `GroupedHistoryStatesQuery`
       instance. timeRange in query should less than 60 data grouping
       intervals.
     - Parameter aggregation: `Aggregation` instance.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments:
       - 1st one is an `AggregatedResult` array.
       - 2nd one is an instance of ThingIFError when failed.
     */
    open func aggregate<AggregatedValueType>(
      _ query: GroupedHistoryStatesQuery,
      aggregation: Aggregation,
      completionHandler: @escaping(
        [AggregatedResult<AggregatedValueType>]?,
        ThingIFError?) -> Void) -> Void
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .post,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states/aliases/\(query.alias)/query",
          requestHeader:
            self.defaultHeader +
            [
              "Content-Type" :
                MediaType.mediaTypeTraitStateQueryRequest.rawValue
            ],
          requestBody:
            [
              "query" : query.makeJsonObject() +
                ["aggregations" : [ aggregation.makeJsonObject() ]]
            ],
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error in

            let result = convertResponse(response, error) {
                response, error throws ->
                            ([AggregatedResult<AggregatedValueType>]?,
                             ThingIFError?) in
                if let error = error {
                    switch error {
                    case .errorResponse(let errorResponse) where
                           errorResponse.httpStatusCode == 409 &&
                             errorResponse.errorCode ==
                             "STATE_HISTORY_NOT_AVAILABLE":
                        return ([], nil)
                    default:
                        return (nil, error)
                    }
                }
                return (
                  try (response!["groupedResults"] as! [[String : Any]]).map {
                      try AggregatedResult($0)
                  },
                  nil)
            }
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }

}
