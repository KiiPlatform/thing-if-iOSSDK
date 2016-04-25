//
//  Predicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents Predicate */
public class Predicate : NSObject, NSCoding {

    public override init() {
        super.init();
    }

    public required init(coder aDecoder: NSCoder) {
        super.init();
    }

    public func encodeWithCoder(aCoder: NSCoder) {
    }

    /** Get Predicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    public func toNSDictionary() -> NSDictionary{
        return NSDictionary()
    }
}
/** Class represents SchedulePredicate. It is not supported now.*/
public class SchedulePredicate: Predicate {
    /** Specified schedule. (cron tab format) */
    public let schedule: String

    /** Instantiate new SchedulePredicate.

     -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(schedule: String) {
        self.schedule = schedule
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        self.schedule = aDecoder.decodeObjectForKey("schedule") as! String;
        super.init(coder: aDecoder);
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.schedule, forKey: "schedule");
    }

    /** Get Json object of SchedulePredicate instance

     - Returns: Json object as an instance of NSDictionary
     */
    public override func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.Schedule.rawValue, "schedule":self.schedule])
    }
}

/** Class represents StatePredicate */
public class StatePredicate: Predicate {
    public let triggersWhen: TriggersWhen!
    public let condition: Condition!

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
        super.init(coder: aDecoder);
    }

    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.triggersWhen.rawValue, forKey: "triggersWhen");
        aCoder.encodeObject(self.condition, forKey: "condition");
    }

    /** Get StatePredicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    public override func toNSDictionary() -> NSDictionary {
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
