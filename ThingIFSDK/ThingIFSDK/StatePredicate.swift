//
//  StatePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents StatePredicate */
open class StatePredicate: NSObject, Predicate {
    open let triggersWhen: TriggersWhen
    open let condition: Condition

    open let eventSource: EventSource = EventSource.states

    /** Initialize StatePredicate with Condition and TriggersWhen

     - Parameter condition: Condition of the Trigger.
     - Parameter triggersWhen: Specify TriggersWhen.
     */
    public init(
      _ condition:Condition,
      triggersWhen:TriggersWhen)
    {
        self.triggersWhen = triggersWhen
        self.condition = condition
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "condition")
            as! Condition,
          triggersWhen: TriggersWhen(
            rawValue: aDecoder.decodeObject(forKey: "triggersWhen")
              as! String)!
        )
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.triggersWhen.rawValue, forKey: "triggersWhen");
        aCoder.encode(self.condition, forKey: "condition");
    }

}
