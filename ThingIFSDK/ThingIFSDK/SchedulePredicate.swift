//
//  SchedulePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents SchedulePredicate. */
open class SchedulePredicate: NSObject,Predicate {
    /** Specified schedule. (cron tab format) */
    open let schedule: String

    open func getEventSource() -> EventSource {
        return EventSource.schedule
    }
    /** Instantiate new SchedulePredicate.

     -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(schedule: String) {
        self.schedule = schedule

        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.schedule = aDecoder.decodeObject(forKey: "schedule") as! String;

    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.schedule, forKey: "schedule");
    }

    /** Get Json object of SchedulePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    open func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.schedule.rawValue, "schedule":self.schedule])
    }
}
