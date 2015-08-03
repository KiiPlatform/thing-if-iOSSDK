//
//  Trigger.swift
//  IoTCloudSDK
//

import Foundation

/** Class represents Trigger */
public class Trigger: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement it.
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        self.targetID = TypedID(type:"",id:"")
        self.enabled = true
        self.predicate = Predicate()
        self.command = Command()
    }

    /** ID of the Target */
    public var targetID: TypedID
    /** Flag indicate whether the Trigger is enabled */
    public var enabled: Bool
    /** Predicate of the Trigger */
    public var predicate: Predicate
    /** Command to be fired */
    public var command: Command

    public override init() {
        // TODO: implement it with proper initializer.
        self.targetID = TypedID(type:"",id:"")
        self.enabled = true
        self.predicate = Predicate()
        self.command = Command()
    }
}

/** Class represents Predicate */
public class Predicate {
}

/** Class represents Condition */
public class Condition {
    init(statement:Statement) {
        // TODO: implement it.
    }
}

/** Enum defines when the Trigger is fired based on StatePredicate */
public enum TriggersWhen {
    /** Always fires when the Condition is evaluated as true. */
    case CONDITION_TRUE
    /** Fires when previous State is evaluated as false and current State is evaluated as true. */
    case CONDITION_FALSE_TO_TRUE
    /** Fires when the previous State and current State is evaluated as
    different value. i.e. false to true, true to false. */
    case CONDITION_CHANGED
}

/** Class represents SchedulePredicate */
public class SchedulePredicate: Predicate {
    /** Specified schedule. (cron tab format) */
    public let schedule: String
    /** Instantiate new SchedulePredicate.
    -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(schedule: String) {
        self.schedule = schedule
    }
}

/** Class represents StatePredicate */
public class StatePredicate: Predicate {
    /** Initialize StatePredicate with Condition and TriggersWhen
    - Parameter condition: Condition of the Trigger.
    - Parameter triggersWhen: Specify TriggersWhen.
     */
    public init(condition:Condition, triggersWhen:TriggersWhen) {
        // TODO: implement it.
    }
}