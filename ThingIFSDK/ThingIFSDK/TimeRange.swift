//
//  TimeRange.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Time range. */
public struct TimeRange {

    /** Start point of a time range. Inclusive. */
    public let from: Date
    /** End point of a time range. Inclusive. */
    public let to: Date

    /** Initialize with form date and to date.

     - Parameter form: Start point of time range. Inclusive
     - Parameter to: End point of time range. Inclusive
     */
    public init(_ from: Date, to: Date) {
        self.from = from
        self.to = to
    }

}

extension TimeRange: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let from = jsonObject["from"] as? Int64,
              let to = jsonObject["to"] as? Int64 else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          Date(timeIntervalSince1970InMillis: from),
          to: Date(timeIntervalSince1970InMillis: to))
    }
}
