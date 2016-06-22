//
//  SchedulePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents SchedulePredicate. */
public class SchedulePredicate: NSObject,Predicate {
    /** Specified schedule. (cron tab format) */
    public let schedule: String

    public func getEventSource() -> EventSource {
        return EventSource.Schedule
    }
    /** Instantiate new SchedulePredicate.

     -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(schedule: String) {
        self.schedule = schedule

        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.schedule = aDecoder.decodeObjectForKey("schedule") as! String;

    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.schedule, forKey: "schedule");
    }

    /** Get Json object of SchedulePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.Schedule.rawValue, "schedule":self.schedule])
    }
}
