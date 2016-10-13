//
//  Command.swift
//  ThingIFSDK
//
import Foundation

/** Class represents Command */
public class Command: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.commandID, forKey: "commandID")
        aCoder.encodeObject(self.targetID, forKey: "targetID")
        aCoder.encodeObject(self.issuerID, forKey: "issuerID")
        aCoder.encodeObject(self.schemaName, forKey: "schemaName")
        aCoder.encodeInteger(self.schemaVersion, forKey: "schemaVersion")
        aCoder.encodeObject(self.actions, forKey: "actions")
        aCoder.encodeObject(self.actionResults, forKey: "actionResults")
        aCoder.encodeInteger(self.commandState.rawValue, forKey: "commandState")
        aCoder.encodeObject(self.firedByTriggerID, forKey: "firedByTriggerID")
        if let date = self.created {
            aCoder.encodeDouble(date.timeIntervalSince1970, forKey: "created")
        }
        if let date = self.modified {
            aCoder.encodeDouble(date.timeIntervalSince1970, forKey: "modified")
        }
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.commandDescription, forKey: "commandDescription")
        aCoder.encodeObject(self.metadata, forKey: "metadata")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.commandID = aDecoder.decodeObjectForKey("commandID") as! String
        self.targetID = aDecoder.decodeObjectForKey("targetID") as! TypedID
        self.issuerID = aDecoder.decodeObjectForKey("issuerID") as! TypedID
        self.schemaName = aDecoder.decodeObjectForKey("schemaName") as! String
        self.schemaVersion = aDecoder.decodeIntegerForKey("schemaVersion")
        self.actions = aDecoder.decodeObjectForKey("actions")
                as! [Dictionary<String, AnyObject>];
        self.actionResults = aDecoder.decodeObjectForKey("actionResults")
                as! [Dictionary<String, AnyObject>];
        self.commandState =
            CommandState(rawValue: aDecoder.decodeIntegerForKey("commandState"))!;
        self.firedByTriggerID = aDecoder.decodeObjectForKey("firedByTriggerID") as? String
        if aDecoder.containsValueForKey("created") {
            self.created = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("created"))
        } else {
            self.created = nil
        }
        if aDecoder.containsValueForKey("modified") {
            self.modified = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("modified"))
        } else {
            self.modified = nil
        }
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.commandDescription = aDecoder.decodeObjectForKey("commandDescription") as? String
        self.metadata = aDecoder.decodeObjectForKey("metadata") as? Dictionary<String, AnyObject>
    }


    /** ID of the Command. */
    public let commandID: String
    /** ID of the Command Target. */
    public let targetID: TypedID
    /** ID of the issuer of the Command. */
    public let issuerID: TypedID
    /** Name of the Schema of which this Command is defined. */
    public let schemaName: String
    /** Version of the Schema of which this Command is defined. */
    public let schemaVersion: Int
    /** Actions to be executed. */
    public let actions: [Dictionary<String, AnyObject>]
    /** Results of the action. */
    public let actionResults: [Dictionary<String, AnyObject>]
    /** State of the Command. */
    public let commandState: CommandState
    /** ID of the trigger which fired this command */
    public let firedByTriggerID: String?
    /** Creation time of the Command.*/
    public let created: NSDate?
    /** Modification time of the Command. */
    public let modified: NSDate?
    /** Title of the Command */
    public let title: String?
    /** Description of the Command */
    public let commandDescription: String?
    /** Metadata of the Command */
    public let metadata: Dictionary<String, AnyObject>?

    public override init() {
        // TODO: implement it with proper initilizer.
        self.commandID = ""
        self.targetID = TypedID(type: "", id: "")
        self.issuerID = TypedID(type: "", id: "")
        self.schemaName = ""
        self.schemaVersion = 0
        self.actions = []
        self.actionResults = []
        self.commandState = CommandState.SENDING
        self.firedByTriggerID = nil
        self.created = nil
        self.modified = nil
        self.title = nil
        self.commandDescription = nil
        self.metadata = nil
    }

    init(commandID: String?,
         targetID: TypedID,
         issuerID: TypedID,
         schemaName: String,
         schemaVersion: Int,
         actions:[Dictionary<String, AnyObject>],
         actionResults:[Dictionary<String, AnyObject>]?,
         commandState: CommandState?,
         firedByTriggerID: String? = nil,
         created: NSDate? = nil,
         modified: NSDate? = nil,
         title: String? = nil,
         commandDescription: String? = nil,
         metadata: Dictionary<String, AnyObject>? = nil) {
        if commandID != nil {
            self.commandID = commandID!
        }else {
            self.commandID = ""
        }
        self.targetID = targetID
        self.issuerID = issuerID
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions

        if actionResults != nil {
            self.actionResults = actionResults!
        }else {
            self.actionResults = []
        }
        if commandState != nil {
            self.commandState = commandState!
        }else {
            self.commandState = CommandState.SENDING
        }
        self.firedByTriggerID = firedByTriggerID
        self.created = created
        self.modified = modified
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aCommand = object as? Command else{
            return false
        }
        
        return self.commandID == aCommand.commandID &&
            self.targetID == aCommand.targetID &&
            self.issuerID == aCommand.issuerID &&
            self.schemaName == aCommand.schemaName &&
            self.schemaVersion == aCommand.schemaVersion
        
    }

    class func commandWithNSDictionary(nsDict: NSDictionary!) -> Command?{

        let commandID = nsDict["commandID"] as? String
        let schemaName = nsDict["schema"] as? String
        // actions array
        var actionsArray = [Dictionary<String, AnyObject>]()
        if let actions = nsDict["actions"] as? [NSDictionary] {
            actionsArray = actions as! [Dictionary<String, AnyObject>]
        }
        // actionResult array
        var actionsResultArray = [Dictionary<String, AnyObject>]()
        if let actionResults = nsDict["actionResults"] as? [NSDictionary] {
            actionsResultArray = actionResults as! [Dictionary<String, AnyObject>]
        }
        let schemaVersion = nsDict["schemaVersion"] as? Int

        var targetID: TypedID?
        if let targetString = nsDict["target"] as? String {
            var targetInfoArray = targetString.componentsSeparatedByString(":")
            if targetInfoArray.count == 2 {
                targetID = TypedID(type: targetInfoArray[0], id: targetInfoArray[1])
            }
        }

        var issuerID: TypedID?
        if let issureString = nsDict["issuer"] as? String {
            var issuerInfoArray = issureString.componentsSeparatedByString(":")
            if issuerInfoArray.count == 2 {
                issuerID = TypedID(type: issuerInfoArray[0], id: issuerInfoArray[1])
            }
        }

        var commandState: CommandState?
        if let commandStateString = nsDict["commandState"] as? String {
            switch commandStateString {
            case "SENDING":
                commandState = CommandState.SENDING
            case "DELIVERED":
                commandState = CommandState.DELIVERED
            case "INCOMPLETE":
                commandState = CommandState.INCOMPLETE
            default:
                commandState = CommandState.DONE
            }
        }
        if targetID == nil || issuerID == nil || schemaName == nil || schemaVersion == nil {
            return nil
        }
        var created: NSDate? = nil
        if let createdAt = nsDict["createdAt"] as? NSNumber {
            created = NSDate(timeIntervalSince1970: (createdAt.doubleValue)/1000.0)
        }
        var modified: NSDate? = nil
        if let modifiedAt = nsDict["modifiedAt"] as? NSNumber {
            modified = NSDate(timeIntervalSince1970: (modifiedAt.doubleValue)/1000.0)
        }
        return Command(commandID: commandID, targetID: targetID!, issuerID: issuerID!, schemaName: schemaName!, schemaVersion: schemaVersion!, actions: actionsArray, actionResults: actionsResultArray, commandState: commandState, firedByTriggerID: nsDict["firedByTriggerID"] as? String, created: created, modified: modified, title: nsDict["title"] as? String, commandDescription: nsDict["description"] as? String, metadata: nsDict["metadata"] as? Dictionary<String, AnyObject>)
    }
}

/** Enum represents state of the Command. */
public enum CommandState: Int {
    /* NOTE: These numbers must not be changed.
       These numbers are used serialization and deserialization
       If thses numbers are changed, then serialization and deserialization
       is broken. */
    /** SENDING Command */
    case SENDING = 1
    /** Command is published to the Target. */
    case DELIVERED = 2
    /** Target returns execution result but not completed all actions successfully. */
    case INCOMPLETE = 3
    /** Target returns execution result and all actions successfully done. */
    case DONE = 4
}
