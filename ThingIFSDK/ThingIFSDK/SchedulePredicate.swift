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
