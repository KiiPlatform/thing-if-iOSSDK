//
//  Utilities.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal func +<Key, Value>(
  left: [Key : Value],
  right: [Key : Value]) -> [Key : Value]
{
    var retval = left
    for (key, value) in right {
        retval[key] = value
    }
    return retval
}

internal func +=<Key, Value>(left: inout [Key : Value], right: [Key : Value]) {
    right.forEach { left[$0.0] = $0.1 }
}

internal func parseResponse<ParsableType: FromJsonObject>(
  _ response: [String :Any]?,
  _ error: ThingIFError?) -> (ParsableType?, ThingIFError?)
{
    if error != nil {
        return (nil, error)
    } else {
        do {
            return (try ParsableType(response!), nil)
        } catch ThingIFError.jsonParseError {
            kiiSevereLog(
              "Server error. Response is not satisfied the spec." +
                response!.description)
            return (nil, ThingIFError.jsonParseError)
        } catch let error {
            kiiSevereLog(
              "Unexpected error." +
                error.localizedDescription)
            return (nil, ThingIFError.jsonParseError)
        }
    }

}

internal extension OperationQueue {

    func addHttpRequestOperation(
      _ method: HTTPMethod,
      url: String,
      requestHeader: [String : String],
      requestBody: [String : Any]? = nil,
      failureBeforeExecutionHandler: @escaping (_ error: ThingIFError) -> Void,
      completionHandler:
        @escaping (_ response: [String : Any]?,
                   _ error: ThingIFError?) -> Void) -> Void
    {
        let data: Data?
        if let requestBody = requestBody {
            do {
                data = try JSONSerialization.data(
                  withJSONObject: requestBody,
                  options: JSONSerialization.WritingOptions(rawValue: 0))
            } catch let error {
                kiiSevereLog(error)
                failureBeforeExecutionHandler(ThingIFError.jsonParseError)
                return
            }
        } else {
            data = nil
        }

        self.addOperation(
          IoTRequestOperation(
            request: buildDefaultRequest(
              method,
              urlString: url,
              requestHeaderDict: requestHeader,
              requestBodyData: data) { response, error in
                completionHandler(response, error)
            }
          )
        )
    }
}
