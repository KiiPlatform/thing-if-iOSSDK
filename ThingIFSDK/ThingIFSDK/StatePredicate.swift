//
//  StatePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents StatePredicate */
public struct StatePredicate: Predicate {
    public let triggersWhen: TriggersWhen
    public let condition: Condition

    public let eventSource: EventSource = EventSource.states

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

}
