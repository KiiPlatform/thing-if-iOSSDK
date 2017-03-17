//
//  ThingIFAPI+Query.swift
//  ThingIFSDK
//
//  Created on 2017/03/17.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

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

        // generate body
        let requestBody : [ String : Any] = ["query" : query.makeJsonObject() + ["aggregations" : [ aggregation.makeJsonObject() ]] ]

        self.operationQueue.addHttpRequestOperation(
            .post,
            url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states/aliases/\(query.alias)/query",
            requestHeader:
            self.defaultHeader + ["Content-Type" : MediaType.mediaTypeTraitStateQueryRequest.rawValue],
            requestBody: requestBody,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                var results : [AggregatedResult<AggregatedValueType>]? = nil
                if let response = response {
                    results = []
                    let queryResults = response["groupedResults"] as! [[String:Any]]
                    for result in queryResults {
                        var value: AggregatedValueType? = nil
                        var history: [HistoryState] = []
                        let range = result["range"] as! [String: Double]
                        let timeRange = TimeRange(
                            Date(timeIntervalSince1970:range["from"]!),
                            to: Date(timeIntervalSince1970:range["to"]!))
                        let aggregation = (result["aggregations"] as! [[String: Any]])[0]
                        if aggregation["value"] != nil {
                            value = aggregation["value"] as? AggregatedValueType
                        }
                        if aggregation["object"] != nil {
                            do {
                                let object = aggregation["object"] as! [String: Any]
                                history.append(try HistoryState(object))
                            } catch let error {
                                DispatchQueue.main.async {
                                    completionHandler(nil, error as? ThingIFError)
                                }
                                return;
                            }
                        }
                        results!.append(
                            AggregatedResult<AggregatedValueType>(
                                value,
                                timeRange: timeRange,
                                aggregatedObjects: history))
                    }
                } else if error != nil {
                    switch error! {
                    case .errorResponse(let errorResponse):
                        if errorResponse.httpStatusCode == 409 &&
                            errorResponse.errorCode == "STATE_HISTORY_NOT_AVAILABLE" {
                            DispatchQueue.main.async {
                                completionHandler([], nil)
                            }
                            return;
                        }
                        break
                    default:
                        break
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(results, error)
                }
            }
    }

}
