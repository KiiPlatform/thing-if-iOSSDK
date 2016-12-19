//
//  StatePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents StatePredicate */
open class StatePredicate<ConcreteAlias: Alias>: NSObject,Predicate {
    open let triggersWhen: TriggersWhen
    open let condition: Condition<ConcreteAlias>

    open let eventSource: EventSource = EventSource.states

    /** Initialize StatePredicate with Condition and TriggersWhen

     - Parameter condition: Condition of the Trigger.
     - Parameter triggersWhen: Specify TriggersWhen.
     */
    public init(
      _ condition:Condition<ConcreteAlias>,
      _ triggersWhen:TriggersWhen)
    {
        self.triggersWhen = triggersWhen
        self.condition = condition
        super.init();
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "condition")
            as! Condition<ConcreteAlias>,
          TriggersWhen(
            rawValue: aDecoder.decodeObject(forKey: "triggersWhen")
              as! String)!
        )
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.triggersWhen.rawValue, forKey: "triggersWhen");
        aCoder.encode(self.condition, forKey: "condition");
    }

    /** Get StatePredicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    open func makeDictionary() -> [ String : Any ]  {
        return [
          "eventSource": EventSource.states.rawValue,
          "triggersWhen": self.triggersWhen.rawValue,
          "condition": self.condition.makeDictionary()] as [ String : Any ]
    }

    /*
     TODO: We should change a method below to initializer. We will do
     that in another PR.

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
    */
}
