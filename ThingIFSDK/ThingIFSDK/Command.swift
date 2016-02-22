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
        self.actions = []
        self.actionResults = []
        self.commandState = CommandState.SENDING
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
    /** Title of the Command */
    public var title: String?
    /** Description of the Command */
    public var commandDescription: String?
    /** Metadata of the Command */
    public var metadata: Dictionary<String, AnyObject>?

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
        self.title = nil
        self.commandDescription = nil
        self.metadata = nil
    }

    init(commandID: String?, targetID: TypedID, issuerID: TypedID, schemaName: String, schemaVersion: Int, actions:[Dictionary<String, AnyObject>], actionResults:[Dictionary<String, AnyObject>]?, commandState: CommandState?) {
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
        self.title = nil
        self.commandDescription = nil
        self.metadata = nil
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
        var command: Command?
        if ((targetID != nil) && (issuerID != nil) && (schemaName != nil)) && (schemaVersion != nil) {
                command = Command(commandID: commandID, targetID: targetID!, issuerID: issuerID!, schemaName: schemaName!, schemaVersion: schemaVersion!, actions: actionsArray, actionResults: actionsResultArray, commandState: commandState)
        }
        if command != nil {
            let title = nsDict["title"] as? String
            if title != nil {
                command?.title = title
            }
            let triggerDescription = nsDict["description"] as? String
            if triggerDescription != nil {
                command?.commandDescription = triggerDescription
            }
            let metadata = nsDict["metadata"] as? Dictionary<String, AnyObject>
            if metadata != nil {
                command?.metadata = metadata
            }
        }

        return command
    }
}

/** Enum represents state of the Command. */
public enum CommandState {
    /** SENDING Command */
    case SENDING
    /** Command is published to the Target. */
    case DELIVERED
    /** Target returns execution result but not completed all actions successfully. */
    case INCOMPLETE
    /** Target returns execution result and all actions successfully done. */
    case DONE
}