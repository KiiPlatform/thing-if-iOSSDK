//
//  StatePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

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