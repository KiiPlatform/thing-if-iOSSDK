//
//  ScheduleOncePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

/** Class represents ScheduleOncePredicate. */
open class ScheduleOncePredicate: Predicate {
    /** Specified schedule. */
    open let scheduleAt: Date

    open let eventSource: EventSource = EventSource.scheduleOnce

    /** Instantiate new ScheduleOncePredicate.

     -Parameter scheduleAt: Specify execution schedule. It must be future date.
     */
    public init(_ scheduleAt: Date) {
        self.scheduleAt = scheduleAt
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
    open func makeDictionary() -> [ String : Any ] {

        let dateNumber = NSNumber(value: Int64(self.scheduleAt.timeIntervalSince1970 * 1000) as Int64)

        return [
          "eventSource": EventSource.scheduleOnce.rawValue,
          "scheduleAt":dateNumber] as [ String : Any ]

    }
}

