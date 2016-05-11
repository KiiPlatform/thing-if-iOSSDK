//
//  ScheduleOncePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

/** Class represents ScheduleOncePredicate. */
public class ScheduleOncePredicate: NSObject,Predicate {
    /** Specified schedule. */
    public let scheduleAt: NSDate

    public func getEventSource() -> EventSource {
        return EventSource.ScheduleOnce
    }
    
    /** Instantiate new ScheduleOncePredicate.

     -Parameter scheduleAt: Specify execution schedule. It must be future date.
     */
    public init(scheduleAt: NSDate) {
        self.scheduleAt = scheduleAt
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.scheduleAt = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("scheduleAt"))
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.scheduleAt.timeIntervalSince1970, forKey: "scheduleAt")
    }

    /** Get Json object of ScheduleOncePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    public func toNSDictionary() -> NSDictionary {

        let dateNumber = NSNumber(longLong: Int64(self.scheduleAt.timeIntervalSince1970 * 1000))

        return NSDictionary(dictionary: ["eventSource": EventSource.ScheduleOnce.rawValue,
            "scheduleAt":dateNumber])

    }
}

