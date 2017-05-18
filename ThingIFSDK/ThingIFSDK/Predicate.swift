//
//  Predicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol represents Predicate */
public protocol Predicate {


    /** Event source of this predicate.

     See `EventSource`
     */
    var eventSource: EventSource { get }
}

internal func makePredicate(_ jsonObject: [String : Any]) throws -> Predicate {
    guard let eventSource = jsonObject["eventSource"] as? String else {
        throw ThingIFError.jsonParseError
    }

    switch eventSource {
    case EventSource.states.rawValue:
        return try StatePredicate(jsonObject)
    case EventSource.schedule.rawValue:
        return try SchedulePredicate(jsonObject)
    case EventSource.scheduleOnce.rawValue:
        return try ScheduleOncePredicate(jsonObject)
    default:
        throw ThingIFError.jsonParseError
    }
}
