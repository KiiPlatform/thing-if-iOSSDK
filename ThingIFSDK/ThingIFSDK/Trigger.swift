//
//  Trigger.swift
//  ThingIFSDK
//

import Foundation

/** Class represents Trigger */
public class Trigger: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.triggerID, forKey: "triggerID")
        aCoder.encodeObject(self.targetID, forKey: "targetID")
        aCoder.encodeObject(self.command, forKey: "command")
        aCoder.encodeObject(self.serverCode, forKey: "serverCode")
        aCoder.encodeBool(self.enabled, forKey: "enabled")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.triggerID = aDecoder.decodeObjectForKey("triggerID") as! String
        self.targetID = aDecoder.decodeObjectForKey("targetID") as! TypedID
        self.enabled = aDecoder.decodeBoolForKey("enabled")
        self.predicate = Predicate()
        self.command = aDecoder.decodeObjectForKey("command") as? Command
        self.serverCode = aDecoder.decodeObjectForKey("serverCode") as? ServerCode
        // TODO: add aditional decoder
    }
    
    var triggersWhat: TriggersWhat? {
        get {
            if self.command != nil {
                return TriggersWhat.COMMAND
            } else if self.serverCode != nil {
                return TriggersWhat.SERVER_CODE
            } else {
                return nil
            }
        }
    }

    class func triggerWithNSDict(triggerDict: NSDictionary) -> Trigger?{
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
    public var command: Command?
    /** ServerCode to be fired */
    public var serverCode: ServerCode?

    public override init() {
        // TODO: implement it with proper initializer.
        self.triggerID = ""
        self.targetID = TypedID(type:"",id:"")
        self.enabled = false
        self.predicate = Predicate()
        self.command = nil
        self.serverCode = nil
    }

    /** Init Trigger with Command

    - Parameter triggerID: ID of trigger
    - Parameter targetID: ID of target
    - Parameter enabled: True to enable trigger
    - Parameter predicate: Predicate instance
    - Parameter command: Command instance
    */
    public init(triggerID: String, targetID: TypedID, enabled: Bool, predicate: Predicate, command: Command) {
        self.triggerID = triggerID
        self.targetID = targetID
        self.enabled = enabled
        self.predicate = predicate
        self.command = command
        self.serverCode = nil
    }
    /** Init Trigger with Server code
     
     - Parameter triggerID: ID of trigger
     - Parameter targetID: ID of target
     - Parameter enabled: True to enable trigger
     - Parameter predicate: Predicate instance
     - Parameter serverCode: ServerCode instance
     */
    public init(triggerID: String, targetID: TypedID, enabled: Bool, predicate: Predicate, serverCode: ServerCode) {
        self.triggerID = triggerID
        self.targetID = targetID
        self.enabled = enabled
        self.predicate = predicate
        self.command = nil
        self.serverCode = serverCode
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTrigger = object as? Trigger else{
            return false
        }

        return self.targetID == aTrigger.targetID &&
            self.enabled == aTrigger.enabled &&
            self.command == aTrigger.command &&
            self.serverCode == aTrigger.serverCode
    }

}

/** Class represents Predicate */
public class Predicate {

    /** Get Predicate as NSDictionary instance

    - Returns: a NSDictionary instance
    */
    public func toNSDictionary() -> NSDictionary{
        return NSDictionary()
    }
}

/** Class represents Condition */
public class Condition {
    public let clause: Clause!

    /** Init Condition with Clause

    - Parameter clause: Clause instance
    */
    public init(clause:Clause) {
        self.clause = clause
    }

    /** Get Condition as NSDictionary instance

    - Returns: a NSDictionary instance
    */
    public func toNSDictionary() -> NSDictionary {
        return self.clause.toNSDictionary()
    }

    class func conditionWithNSDict(conditionDict: NSDictionary) -> Condition?{
        if let clause = Condition.clauseWithNSDict(conditionDict) {
            return Condition(clause: clause)
        }else {
            return nil
        }
    }

    class func clauseWithNSDict(clauseDict: NSDictionary) -> Clause?{
        var clause: Clause?
        if let type = clauseDict["type"] as? String {
            switch type {
            case "range":
                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber, lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber, field = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool, lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: field, lowerLimit: lowerLimitNumber.integerValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.integerValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: field, lowerLimit: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber,
                    filed = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: filed, upperLimit: upperLimitNumber.integerValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, upperLimit: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber,
                    filed = clauseDict["field"] as? String {
                    if let lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if lowerLimitNumber.isInt() {
                            clause = RangeClause(field: filed, lowerLimit: lowerLimitNumber.integerValue, lowerIncluded: lowerIncluded)
                        }else if lowerLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, lowerLimit: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded)
                        }
                    }
                    break
                }
                break

            case "eq":
                if let field = clauseDict["field"] as? String, value = clauseDict["value"] {
                    if value is String {
                        clause = EqualsClause(field: field, value: value as! String)
                    }else if value is NSNumber {
                        let numberValue = value as! NSNumber
                        if numberValue.isBool() {
                            clause = EqualsClause(field: field, value: numberValue.boolValue)
                        }else {
                            clause = EqualsClause(field: field, value: numberValue.integerValue)
                        }
                    }
                }

            case "not":
                if let clauseDict = clauseDict["clause"] as? NSDictionary {
                    if let equalClause = Condition.clauseWithNSDict(clauseDict) as? EqualsClause{
                        clause = NotEqualsClause(equalStmt: equalClause)
                    }
                }

            case "and":
                let andClause = AndClause()
                if let clauseDicts = clauseDict["clauses"] as? NSArray {
                    for clauseDict in clauseDicts {
                        if let subClause = Condition.clauseWithNSDict(clauseDict as! NSDictionary) {
                            andClause.add(subClause)
                        }
                    }
                }
                clause = andClause

            case "or":
                let orClause = OrClause()
                if let clauseDicts = clauseDict["clauses"] as? NSArray {
                    for clauseDict in clauseDicts {
                        if let subClause = Condition.clauseWithNSDict(clauseDict as! NSDictionary) {
                            orClause.add(subClause)
                        }
                    }
                }
                clause = orClause

            default:
                break
            }
        }
        return clause
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
    public func toString() -> String {
        switch self {
        case .CONDITION_FALSE_TO_TRUE:
            return "CONDITION_FALSE_TO_TRUE"
        case .CONDITION_TRUE:
            return "CONDITION_TRUE"
        case .CONDITION_CHANGED:
            return "CONDITION_CHANGED"
        }
    }

    /** Init from string

    - Prameter string: String value of triggerswhen to init
    */
    public init?(string: String) {
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
public enum TriggersWhat {
    case COMMAND
    case SERVER_CODE
    
    /** Get String value of TriggerWhat */
    public func toString() -> String {
        switch self {
        case .COMMAND:
            return "COMMAND"
        case .SERVER_CODE:
            return "SERVER_CODE"
        }
    }
    
    /** Init from string
     
     - Prameter string: String value of triggerswhat to init
     */
    public init?(string: String) {
        switch string {
        case "COMMAND":
            self = .COMMAND
        case "SERVER_CODE":
            self = .SERVER_CODE
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
    public let triggersWhen: TriggersWhen!
    public let condition: Condition!

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

    class func statePredicateWithNSDict(predicateDict: NSDictionary) -> StatePredicate?{
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

public class ServerCode : NSObject, NSCoding {
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.endpoint, forKey: "endpoint")
        aCoder.encodeObject(self.executorAccessToken, forKey: "executorAccessToken")
        aCoder.encodeObject(self.targetAppID, forKey: "targetAppID")
        aCoder.encodeObject(self.parameters, forKey: "parameters")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.endpoint = aDecoder.decodeObjectForKey("endpoint") as! String
        self.executorAccessToken = aDecoder.decodeObjectForKey("executorAccessToken") as! String
        self.targetAppID = aDecoder.decodeObjectForKey("targetAppID") as? String
        self.parameters = aDecoder.decodeObjectForKey("parameters") as? Dictionary<String, AnyObject>
    }
    
    /** Endpoint to call on servercode */
    public var endpoint: String
    /** This token will be used to call the external appID endpoint */
    public var executorAccessToken: String
    /** If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used */
    public var targetAppID: String?
    /** Parameters to pass to the servercode function */
    public var parameters: Dictionary<String, AnyObject>?

    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter endpoint: Endpoint to call on servercode
     - Parameter executorAccessToken: This token will be used to call the external appID endpoint
     - Parameter targetAppID: If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used
     - Parameter parameters: Parameters to pass to the servercode function
     */
    public init(endpoint: String, executorAccessToken: String, targetAppID: String?, parameters: Dictionary<String, AnyObject>?) {
        self.endpoint = endpoint
        self.executorAccessToken = executorAccessToken
        self.targetAppID = targetAppID
        self.parameters = parameters
    }

    public func toNSDictionary() -> NSDictionary {
        let dict = NSMutableDictionary(dictionary: ["endpoint": self.endpoint, "executorAccessToken": self.executorAccessToken])
        if self.targetAppID != nil {
            dict["targetAppID"] = self.targetAppID
        }
        if self.parameters != nil {
            dict["parameters"] = self.parameters
        }
        return dict
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aServerCode = object as? ServerCode else{
            return false
        }
        return self.endpoint == aServerCode.endpoint &&
            self.executorAccessToken == aServerCode.executorAccessToken &&
            self.targetAppID! == aServerCode.targetAppID! &&
            NSDictionary(dictionary: self.parameters!).isEqualToDictionary(aServerCode.parameters!)
        
    }
}

