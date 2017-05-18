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

extension StatePredicate: FromJsonObject, ToJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let eventSource = jsonObject["eventSource"] as? String,
              let triggersWhenStr = jsonObject["triggersWhen"] as? String,
              let triggersWhen = TriggersWhen(rawValue: triggersWhenStr),
              let condition = jsonObject["condition"] as? [String : Any] else {
            throw ThingIFError.jsonParseError
        }

        if eventSource != EventSource.states.rawValue {
            throw ThingIFError.jsonParseError
        }

        self.init(try Condition(condition), triggersWhen: triggersWhen)
    }

    public func makeJsonObject() -> [String : Any] {
        return [
          "eventSource" : self.eventSource.rawValue,
          "triggersWhen" : self.triggersWhen.rawValue,
          "condition" : self.condition.makeJsonObject()
        ]
    }

}
