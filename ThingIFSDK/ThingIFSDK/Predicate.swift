//
//  Predicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol represents Predicate */
public protocol Predicate :  NSCoding {


    /** Get Predicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    func toNSDictionary() -> NSDictionary

    /** Get EventSource enum

     - Returns: an enumeration instance of the event source.
     */
    func getEventSource() -> EventSource
}
/** Class represents SchedulePredicate. It is not supported now.*/
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

/** Class represents StatePredicate */
public class StatePredicate: NSObject,Predicate {
    public let triggersWhen: TriggersWhen!
    public let condition: Condition!

    public func getEventSource() -> EventSource {
        return EventSource.States
    }
    /** Initialize StatePredicate with Condition and TriggersWhen

     - Parameter condition: Condition of the Trigger.
     - Parameter triggersWhen: Specify TriggersWhen.
     */
    public init(condition:Condition, triggersWhen:TriggersWhen) {
        self.triggersWhen = triggersWhen
        self.condition = condition
        super.init();
    }

    public required init(coder aDecoder: NSCoder) {
        self.triggersWhen = TriggersWhen(rawValue: aDecoder.decodeObjectForKey("triggersWhen") as! String);
        self.condition = aDecoder.decodeObjectForKey("condition") as! Condition;
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.triggersWhen.rawValue, forKey: "triggersWhen");
        aCoder.encodeObject(self.condition, forKey: "condition");
    }

    /** Get StatePredicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.States.rawValue, "triggersWhen": self.triggersWhen.rawValue, "condition": self.condition.toNSDictionary()])
    }

    class func statePredicateWithNSDict(predicateDict: NSDictionary) -> StatePredicate?{
        var triggersWhen: TriggersWhen?
        var condition: Condition?
        if let triggersWhenString = predicateDict["triggersWhen"] as? String {
            triggersWhen = TriggersWhen(rawValue: triggersWhenString)
        }

        if let conditionDict = predicateDict["condition"] as? NSDictionary {
            condition = Condition.conditionWithNSDict(conditionDict)
        }

        if triggersWhen != nil && condition != nil {
            return StatePredicate(condition: condition!, triggersWhen: triggersWhen!)
        }else {
            return nil
        }
    }
}

/** Class represents ScheduleOncePredicate. */
public class ScheduleOncePredicate: NSObject,Predicate {
    /** Specified schedule. (cron tab format) */
    public let scheduleAt: NSDate

    public func getEventSource() -> EventSource {
        return EventSource.ScheduleOnce
    }
    /** Instantiate new ScheduleOncePredicate.

     -Parameter scheduleAt: Specify execution schedule. It must be future date.
     */
    public init?(scheduleAt: NSDate) {
        //TODO: implementations, please ignore
        self.scheduleAt = scheduleAt

        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        //TODO: implementations, please ignore
        self.scheduleAt = aDecoder.decodeObjectForKey("schedule") as! NSDate;

    }

    public func encodeWithCoder(aCoder: NSCoder) {
        //TODO: implementations, please ignore
        aCoder.encodeObject(self.scheduleAt, forKey: "schedule");
    }

    /** Get Json object of SchedulePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    public func toNSDictionary() -> NSDictionary {
        //TODO: implementations, please ignore
        return NSDictionary(dictionary: ["eventSource": EventSource.ScheduleOnce.rawValue, "schedule":self.scheduleAt])
    }
}

