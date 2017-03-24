//
//  SchedulePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents SchedulePredicate. */
public struct SchedulePredicate: Predicate {
    /** Specified schedule. (cron tab format) */
    public let schedule: String

    public let eventSource: EventSource = EventSource.schedule

    /** Instantiate new SchedulePredicate.

     -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(_ schedule: String) {
        self.schedule = schedule
    }

}

extension SchedulePredicate: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let eventSource = jsonObject["eventSource"] as? String,
              let schedule = jsonObject["schedule"] as? String else {
            throw ThingIFError.jsonParseError
        }

        if eventSource != EventSource.schedule.rawValue {
            throw ThingIFError.jsonParseError
        }

        self.init(schedule)
    }

}
