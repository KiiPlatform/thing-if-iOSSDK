//
//  StatePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents StatePredicate */
open class StatePredicate: NSObject,Predicate {
    open let triggersWhen: TriggersWhen!
    open let condition: Condition!

    open func getEventSource() -> EventSource {
        return EventSource.states
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
        self.triggersWhen = TriggersWhen(rawValue: aDecoder.decodeObject(forKey: "triggersWhen") as! String);
        self.condition = aDecoder.decodeObject(forKey: "condition") as! Condition;
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.triggersWhen.rawValue, forKey: "triggersWhen");
        aCoder.encode(self.condition, forKey: "condition");
    }

    /** Get StatePredicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    open func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.states.rawValue, "triggersWhen": self.triggersWhen.rawValue, "condition": self.condition.toNSDictionary()])
    }

    class func statePredicateWithNSDict(_ predicateDict: NSDictionary) -> StatePredicate?{
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
