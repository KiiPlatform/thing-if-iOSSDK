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
        aCoder.encodeObject(self.predicate, forKey: "predicate")
        aCoder.encodeObject(self.command, forKey: "command")
        aCoder.encodeObject(self.serverCode, forKey: "serverCode")
        aCoder.encodeBool(self.enabled, forKey: "enabled")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.triggerDescription, forKey: "triggerDescription")
        aCoder.encodeObject(self.metadata, forKey: "metadata")
        
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.triggerID = aDecoder.decodeObjectForKey("triggerID") as! String
        self.enabled = aDecoder.decodeBoolForKey("enabled")
        self.predicate = aDecoder.decodeObjectForKey("predicate") as! Predicate
        self.command = aDecoder.decodeObjectForKey("command") as? Command
        self.serverCode = aDecoder.decodeObjectForKey("serverCode") as? ServerCode
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.triggerDescription = aDecoder.decodeObjectForKey("triggerDescription") as? String
        self.metadata = aDecoder.decodeObjectForKey("metadata") as? Dictionary<String, AnyObject>
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
                    case EventSource.Schedule:
                        //Not supported yet
                        break
                    }
                }
            }
        }
        if triggerID != nil && predicate != nil && command != nil && disabled != nil{
            trigger = Trigger(triggerID: triggerID!, enabled: !(disabled!), predicate: predicate!, command: command!)
        }
        if triggerID != nil && predicate != nil && serverCode != nil && disabled != nil{
            trigger = Trigger(triggerID: triggerID!, enabled: !(disabled!), predicate: predicate!, serverCode: serverCode!)
        }
        if trigger != nil {
            let title = triggerDict["title"] as? String
            if title != nil {
                trigger?.title = title
            }
            let triggerDescription = triggerDict["description"] as? String
            if triggerDescription != nil {
                trigger?.triggerDescription = triggerDescription
            }
            let metadata = triggerDict["metadata"] as? Dictionary<String, AnyObject>
            if metadata != nil {
                trigger?.metadata = metadata
            }
        }
        
        return trigger
    }

    /** ID of the Trigger */
    public var triggerID: String
    /** Flag indicate whether the Trigger is enabled */
    public var enabled: Bool
    /** Predicate of the Trigger */
    public var predicate: Predicate
    /** Command to be fired */
    public var command: Command?
    /** ServerCode to be fired */
    public var serverCode: ServerCode?
    /** Title of the Trigger */
    public var title: String?
    /** Description of the Trigger */
    public var triggerDescription: String?
    /** Metadata of the Trigger */
    public var metadata: Dictionary<String, AnyObject>?

    public override init() {
        // TODO: implement it with proper initializer.
        self.triggerID = ""
        self.enabled = false
        self.predicate = Predicate()
        self.command = nil
        self.serverCode = nil
        self.title = nil
        self.triggerDescription = nil
        self.metadata = nil
    }

    /** Init Trigger with Command

    - Parameter triggerID: ID of trigger
    - Parameter enabled: True to enable trigger
    - Parameter predicate: Predicate instance
    - Parameter command: Command instance
    */
    public init(triggerID: String, enabled: Bool, predicate: Predicate, command: Command) {
        self.triggerID = triggerID
        self.enabled = enabled
        self.predicate = predicate
        self.command = command
        self.serverCode = nil
        self.title = nil
        self.triggerDescription = nil
        self.metadata = nil
    }
    /** Init Trigger with Server code
     
     - Parameter triggerID: ID of trigger
     - Parameter enabled: True to enable trigger
     - Parameter predicate: Predicate instance
     - Parameter serverCode: ServerCode instance
     */
    public init(triggerID: String, enabled: Bool, predicate: Predicate, serverCode: ServerCode) {
        self.triggerID = triggerID
        self.enabled = enabled
        self.predicate = predicate
        self.command = nil
        self.serverCode = serverCode
        self.title = nil
        self.triggerDescription = nil
        self.metadata = nil
    }

    public override func isEqual(object: AnyObject?) -> Bool {
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
    case CONDITION_TRUE = "CONDITION_TRUE"
    /** Fires when previous State is evaluated as false and current State is evaluated as true. */
    case CONDITION_FALSE_TO_TRUE = "CONDITION_FALSE_TO_TRUE"
    /** Fires when the previous State and current State is evaluated as
    different value. i.e. false to true, true to false. */
    case CONDITION_CHANGED = "CONDITION_CHANGED"
}

public enum TriggersWhat : String {
    case COMMAND = "COMMAND"
    case SERVER_CODE = "SERVER_CODE"
}

enum EventSource: String {
    /* NOTE: These string values must not be changed. These values are
       used serialization and deserialization If thses values are
       changed, then serialization and deserialization is broken. */

    case States = "STATES"
    case Schedule = "SCHEDULE"

}
