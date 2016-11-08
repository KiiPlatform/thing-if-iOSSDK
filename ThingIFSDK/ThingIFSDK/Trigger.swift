//
//  Trigger.swift
//  ThingIFSDK
//

import Foundation

/** Class represents Trigger */
open class Trigger: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.triggerID, forKey: "triggerID")
        aCoder.encode(self.targetID, forKey: "targetID")
        aCoder.encode(self.predicate, forKey: "predicate")
        aCoder.encode(self.command, forKey: "command")
        aCoder.encode(self.serverCode, forKey: "serverCode")
        aCoder.encode(self.enabled, forKey: "enabled")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.triggerDescription, forKey: "triggerDescription")
        aCoder.encode(self.metadata, forKey: "metadata")
        
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.triggerID = aDecoder.decodeObject(forKey: "triggerID") as! String
        self.targetID = aDecoder.decodeObject(forKey: "targetID") as! TypedID
        self.enabled = aDecoder.decodeBool(forKey: "enabled")
        self.predicate = aDecoder.decodeObject(forKey: "predicate") as! Predicate
        self.command = aDecoder.decodeObject(forKey: "command") as? Command
        self.serverCode = aDecoder.decodeObject(forKey: "serverCode") as? ServerCode
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.triggerDescription = aDecoder.decodeObject(forKey: "triggerDescription") as? String
        self.metadata = aDecoder.decodeObject(forKey: "metadata") as? Dictionary<String, Any>
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

    class func triggerWithNSDict(_ targetID: TypedID, triggerDict: NSDictionary) -> Trigger?{
        let triggerID = triggerDict["triggerID"] as? String
        let disabled = triggerDict["disabled"] as? Bool
        var predicate: Predicate?
        var command: Command?
        var serverCode: ServerCode?
        var trigger: Trigger?

        if let commandDict = triggerDict["command"] as? NSDictionary {
            command = Command.commandWithNSDictionary(commandDict)
        }
        if let serverCodeDict = triggerDict["serverCode"] as? NSDictionary {
            serverCode = ServerCode.serverCodeWithNSDictionary(serverCodeDict)
        }

        if let predicateDict = triggerDict["predicate"] as? NSDictionary{
            if let eventSourceString = predicateDict["eventSource"] as? String{
                if let eventSource = EventSource(rawValue: eventSourceString){
                    switch eventSource {
                    case EventSource.States:
                        predicate = StatePredicate.statePredicateWithNSDict(predicateDict)
                        break
                    case EventSource.Schedule:
                        predicate = SchedulePredicate(schedule:  predicateDict["schedule"] as! String)
                        break
                    case EventSource.ScheduleOnce:
                        if let scheduleAtMilis = (predicateDict["scheduleAt"] as? NSNumber)?.doubleValue {
                            predicate = ScheduleOncePredicate(scheduleAt: Date(timeIntervalSince1970: scheduleAtMilis/1000))
                        }
                        break
                    }
                }
            }
        }

        let title = triggerDict["title"] as? String
        let triggerDescription = triggerDict["description"] as? String
        let metadata = triggerDict["metadata"] as? Dictionary<String, Any>

        if triggerID != nil && predicate != nil && command != nil && disabled != nil{
            trigger = Trigger(triggerID: triggerID!, targetID: targetID, enabled: !(disabled!), predicate: predicate!, command: command!, title: title, triggerDescription: triggerDescription, metadata: metadata)
        }
        if triggerID != nil && predicate != nil && serverCode != nil && disabled != nil{
            trigger = Trigger(triggerID: triggerID!, targetID: targetID, enabled: !(disabled!), predicate: predicate!, serverCode: serverCode!, title: title, triggerDescription: triggerDescription, metadata: metadata)
        }
        
        return trigger
    }

    /** ID of the Trigger */
    open let triggerID: String
    /** ID of the Trigger target */
    open let targetID: TypedID
    /** Flag indicate whether the Trigger is enabled */
    open let enabled: Bool
    /** Predicate of the Trigger */
    open let predicate: Predicate
    /** Command to be fired */
    open let command: Command?
    /** ServerCode to be fired */
    open let serverCode: ServerCode?
    /** Title of the Trigger */
    open let title: String?
    /** Description of the Trigger */
    open let triggerDescription: String?
    /** Metadata of the Trigger */
    open let metadata: Dictionary<String, Any>?

    /** Init Trigger with Command

    - Parameter triggerID: ID of trigger
    - Parameter targetID: ID of trigger target
    - Parameter enabled: True to enable trigger
    - Parameter predicate: Predicate instance
    - Parameter command: Command instance
    */
    public init(triggerID: String, targetID: TypedID, enabled: Bool, predicate: Predicate, command: Command, title: String? = nil, triggerDescription: String? = nil, metadata: Dictionary<String, Any>? = nil) {
        self.triggerID = triggerID
        self.targetID = targetID
        self.enabled = enabled
        self.predicate = predicate
        self.command = command
        self.serverCode = nil
        self.title = title
        self.triggerDescription = triggerDescription
        self.metadata = metadata
    }
    /** Init Trigger with Server code
     
     - Parameter triggerID: ID of trigger
     - Parameter targetID: ID of trigger target
     - Parameter enabled: True to enable trigger
     - Parameter predicate: Predicate instance
     - Parameter serverCode: ServerCode instance
     */
    public init(triggerID: String, targetID: TypedID, enabled: Bool, predicate: Predicate, serverCode: ServerCode, title: String? = nil, triggerDescription: String? = nil, metadata: Dictionary<String, Any>? = nil) {
        self.triggerID = triggerID
        self.targetID = targetID
        self.enabled = enabled
        self.predicate = predicate
        self.command = nil
        self.serverCode = serverCode
        self.title = title
        self.triggerDescription = triggerDescription
        self.metadata = metadata
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let aTrigger = object as? Trigger else{
            return false
        }

        return self.enabled == aTrigger.enabled &&
            self.command == aTrigger.command &&
            self.serverCode == aTrigger.serverCode
    }

}

/** Enum defines when the Trigger is fired based on StatePredicate */
public enum TriggersWhen : String {
    /* NOTE: These string values must not be changed. These values are
       used serialization and deserialization If thses values are
       changed, then serialization and deserialization is broken. */

    /** Always fires when the Condition is evaluated as true. */
    case conditionTrue = "CONDITION_TRUE"
    /** Fires when previous State is evaluated as false and current State is evaluated as true. */
    case conditionFalseToTrue = "CONDITION_FALSE_TO_TRUE"
    /** Fires when the previous State and current State is evaluated as
    different value. i.e. false to true, true to false. */
    case conditionChanged = "CONDITION_CHANGED"
}

public enum TriggersWhat : String {
    case COMMAND = "COMMAND"
    case SERVER_CODE = "SERVER_CODE"
}

public enum EventSource: String {
    /* NOTE: These string values must not be changed. These values are
       used serialization and deserialization If thses values are
       changed, then serialization and deserialization is broken. */

    case States = "STATES"
    case Schedule = "SCHEDULE"
    case ScheduleOnce = "SCHEDULE_ONCE"

}
