//
//  Trigger.swift
//  IoTCloudSDK
//

import Foundation

/** Class represents Trigger */
public class Trigger: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.triggerID, forKey: "triggerID")
        aCoder.encodeObject(self.targetID, forKey: "targetID")
        aCoder.encodeObject(self.command, forKey: "command")
        aCoder.encodeBool(self.enabled, forKey: "enabled")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.triggerID = aDecoder.decodeObjectForKey("triggerID") as! String
        self.targetID = aDecoder.decodeObjectForKey("targetID") as! TypedID
        self.enabled = aDecoder.decodeBoolForKey("enabled")
        self.predicate = Predicate()
        self.command = aDecoder.decodeObjectForKey("command") as! Command
        // TODO: add aditional decoder
    }

    public class func triggerWithNSDict(triggerDict: NSDictionary) -> Trigger?{
        let triggerID = triggerDict["triggerID"] as? String
        let disabled = triggerDict["disabled"] as? Bool
        var predicate: Predicate?
        var command: Command?
        var trigger: Trigger?

        if let commandDict = triggerDict["command"] as? NSDictionary {
            command = Command.commandWithNSDictionary(commandDict)
        }

        if let predicateDict = triggerDict["predicate"] as? NSDictionary{
            if let eventSourceString = predicateDict["eventSource"] as? String{
                if let eventSource = EventSource(string: eventSourceString){
                    switch eventSource {
                    case EventSource.States:
                        predicate = StatePredicate.statePredicateWithNSDict(predicateDict)
                    case EventSource.Schedule:
                        //Not supported yet
                        break
                    }
                }
            }
        }
        if triggerID != nil && predicate != nil && command != nil && disabled != nil{
            trigger = Trigger(triggerID: triggerID!, targetID: command!.targetID, enabled: !(disabled!), predicate: predicate!, command: command!)
        }
        return trigger
    }

    /** ID of the Trigger */
    public var triggerID: String
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
        self.triggerID = ""
        self.targetID = TypedID(type:"",id:"")
        self.enabled = false
        self.predicate = Predicate()
        self.command = Command()
    }

    public init(triggerID: String, targetID: TypedID, enabled: Bool, predicate: Predicate, command: Command) {
        self.triggerID = triggerID
        self.targetID = targetID
        self.enabled = enabled
        self.predicate = predicate
        self.command = command
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTrigger = object as? Trigger else{
            return false
        }

        return self.targetID == aTrigger.targetID &&
            self.enabled == aTrigger.enabled &&
            self.command == aTrigger.command
    }

}

/** Class represents Predicate */
public class Predicate {
    public func toNSDictionary() -> NSDictionary{
        return NSDictionary()
    }
}

/** Class represents Condition */
public class Condition {
    var statement: Statement!

    public init(statement:Statement) {
        self.statement = statement
    }

    /** Get Condition as NSDictionary instance
    - Returns: a NSDictionary instance
    */
    public func toNSDictionary() -> NSDictionary {
        return self.statement.toNSDictionary()
    }

    public class func conditionWithNSDict(conditionDict: NSDictionary) -> Condition?{
        if let statement = Condition.statementWithNSDict(conditionDict) {
            return Condition(statement: statement)
        }else {
            return nil
        }
    }
    public class func statementWithNSDict(statementDict: NSDictionary) -> Statement?{
        var statement: Statement?
        if let type = statementDict["type"] as? String {
            switch type {
            case "range":
                if let upperLimit = statementDict["upperLimit"] as? Int,
                    filed = statementDict["field"] as? String {
                    if let upperIncluded = statementDict["upperIncluded"] as? Bool {
                        if upperIncluded {
                            statement = NotGreaterThan(field: filed, upperLimit: upperLimit)
                        }else {
                            statement = LessThan(field: filed, upperLimit: upperLimit)
                        }
                    }
                    break
                }

                if let lowerLimit = statementDict["lowerLimit"] as? Int,
                    filed = statementDict["field"] as? String {
                    if let upperIncluded = statementDict["lowerIncluded"] as? Bool {
                        if upperIncluded {
                            statement = NotLessThan(field: filed, lowerLimit: lowerLimit)
                        }else {
                            statement = GreaterThan(field: filed, lowerLimit: lowerLimit)
                        }
                    }
                    break
                }
                break

            case "eq":
                if let field = statementDict["field"] as? String, value = statementDict["value"] {
                    if value is String {
                        statement = Equals(field: field, value: value as! String)
                    }else if value is NSNumber {
                        let numberValue = value as! NSNumber
                        if numberValue.isBool() {
                            statement = Equals(field: field, value: numberValue.boolValue)
                        }else {
                            statement = Equals(field: field, value: numberValue.integerValue)
                        }
                    }
                }

            case "not":
                if let clauseStatementDict = statementDict["clause"] as? NSDictionary {
                    if let clauseStatement = Condition.statementWithNSDict(clauseStatementDict) as? Equals{
                        statement = NotEquals(equalStmt: clauseStatement)
                    }
                }

            case "and":
                let andStatement = And()
                if let clauseStatementDicts = statementDict["clauses"] as? NSArray {
                    for clauseStatementDict in clauseStatementDicts {
                        if let clauseStatement = Condition.statementWithNSDict(clauseStatementDict as! NSDictionary) {
                            andStatement.add(clauseStatement)
                        }
                    }
                }
                statement = andStatement

            case "or":
                let orStatement = Or()
                if let clauseStatementDicts = statementDict["clauses"] as? NSArray {
                    for clauseStatementDict in clauseStatementDicts {
                        if let clauseStatement = Condition.statementWithNSDict(clauseStatementDict as! NSDictionary) {
                            orStatement.add(clauseStatement)
                        }
                    }
                }
                statement = orStatement

            default:
                break
            }
        }
        return statement
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

    /** Get String value of TriggerWhen */
    func toString() -> String {
        switch self {
        case .CONDITION_FALSE_TO_TRUE:
            return "CONDITION_FALSE_TO_TRUE"
        case .CONDITION_TRUE:
            return "CONDITION_TRUE"
        case .CONDITION_CHANGED:
            return "CONDITION_CHANGED"
        }
    }

    init?(string: String) {
        switch string {
        case "CONDITION_FALSE_TO_TRUE":
            self = .CONDITION_FALSE_TO_TRUE
        case "CONDITION_TRUE":
            self = .CONDITION_TRUE
        case "CONDITION_CHANGED":
            self = .CONDITION_CHANGED
        default: return nil
        }
    }
}

enum EventSource: String {

    case States = "states"
    case Schedule = "schedule"

    init?(string: String) {
        switch string {
        case "states":
            self = .States
        case "schedule":
            self = .Schedule
        default: return nil
        }
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
    var triggersWhen: TriggersWhen!
    var condition: Condition!
    /** Initialize StatePredicate with Condition and TriggersWhen
    - Parameter condition: Condition of the Trigger.
    - Parameter triggersWhen: Specify TriggersWhen.
    */
    public init(condition:Condition, triggersWhen:TriggersWhen) {
        self.triggersWhen = triggersWhen
        self.condition = condition
    }

    /** Get StatePredicate as NSDictionary instance
    - Returns: a NSDictionary instance
    */
    public override func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["eventSource": EventSource.States.rawValue, "triggersWhen": self.triggersWhen.toString(), "condition": self.condition.toNSDictionary()])
    }

    public class func statePredicateWithNSDict(predicateDict: NSDictionary) -> StatePredicate?{
        var triggersWhen: TriggersWhen?
        var condition: Condition?
        if let triggersWhenString = predicateDict["triggersWhen"] as? String {
            triggersWhen = TriggersWhen(string: triggersWhenString)
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
