//
//  ScheduleOncePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

/** Class represents ScheduleOncePredicate. */
open class ScheduleOncePredicate: NSObject,Predicate {
    /** Specified schedule. */
    open let scheduleAt: Date

    open func getEventSource() -> EventSource {
        return EventSource.scheduleOnce
    }
    
    /** Instantiate new ScheduleOncePredicate.

     -Parameter scheduleAt: Specify execution schedule. It must be future date.
     */
    public init(scheduleAt: Date) {
        self.scheduleAt = scheduleAt
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.scheduleAt = aDecoder.decodeObject(forKey: "scheduleAt") as! Date
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.scheduleAt, forKey: "scheduleAt")
    }

    /** Get Json object of ScheduleOncePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    open func toNSDictionary() -> NSDictionary {

        let dateNumber = NSNumber(value: Int64(self.scheduleAt.timeIntervalSince1970 * 1000) as Int64)

        return NSDictionary(dictionary: ["eventSource": EventSource.scheduleOnce.rawValue,
            "scheduleAt":dateNumber])

    }
}

