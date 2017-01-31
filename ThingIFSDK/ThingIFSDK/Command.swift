//
//  Command.swift
//  ThingIFSDK
//
import Foundation

/** Class represents Command */
open class Command: Equatable, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.commandID, forKey: "commandID")
        aCoder.encode(self.targetID, forKey: "targetID")
        aCoder.encode(self.issuerID, forKey: "issuerID")
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.actionResults, forKey: "actionResults")
        aCoder.encode(self.commandState.rawValue, forKey: "commandState")
        aCoder.encode(self.firedByTriggerID, forKey: "firedByTriggerID")
        if let date = self.created {
            aCoder.encode(date.timeIntervalSince1970, forKey: "created")
        }
        if let date = self.modified {
            aCoder.encode(date.timeIntervalSince1970, forKey: "modified")
        }
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription, forKey: "commandDescription")
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.commandID = aDecoder.decodeObject(forKey: "commandID") as! String
        self.targetID = aDecoder.decodeObject(forKey: "targetID") as! TypedID
        self.issuerID = aDecoder.decodeObject(forKey: "issuerID") as! TypedID
        self.actions = aDecoder.decodeObject(forKey: "actions")
                as! [AliasAction]
        self.actionResults = aDecoder.decodeObject(forKey: "actionResults")
                as! [AliasActionResult]
        self.commandState =
            CommandState(rawValue: aDecoder.decodeInteger(forKey: "commandState"))!;
        self.firedByTriggerID = aDecoder.decodeObject(forKey: "firedByTriggerID") as? String
        if aDecoder.containsValue(forKey: "created") {
            self.created = Date(timeIntervalSince1970: aDecoder.decodeDouble(forKey: "created"))
        } else {
            self.created = nil
        }
        if aDecoder.containsValue(forKey: "modified") {
            self.modified = Date(timeIntervalSince1970: aDecoder.decodeDouble(forKey: "modified"))
        } else {
            self.modified = nil
        }
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.commandDescription = aDecoder.decodeObject(forKey: "commandDescription") as? String
        self.metadata = aDecoder.decodeObject(forKey: "metadata") as? Dictionary<String, Any>
    }


    /** ID of the Command. */
    open let commandID: String
    /** ID of the Command Target. */
    open let targetID: TypedID
    /** ID of the issuer of the Command. */
    open let issuerID: TypedID
    /** Actions to be executed. */
    open let actions: [AliasAction]
    /** Results of the action. */
    open let actionResults: [AliasActionResult]
    /** State of the Command. */
    open let commandState: CommandState
    /** ID of the trigger which fired this command */
    open let firedByTriggerID: String?
    /** Creation time of the Command.*/
    open let created: Date?
    /** Modification time of the Command. */
    open let modified: Date?
    /** Title of the Command */
    open let title: String?
    /** Description of the Command */
    open let commandDescription: String?
    /** Metadata of the Command */
    open let metadata: Dictionary<String, Any>?

    internal init(commandID: String,
         targetID: TypedID,
         issuerID: TypedID,
         actions: [AliasAction],
         actionResults: [AliasActionResult]?,
         commandState: CommandState?,
         firedByTriggerID: String? = nil,
         created: Date? = nil,
         modified: Date? = nil,
         title: String? = nil,
         commandDescription: String? = nil,
         metadata: Dictionary<String, Any>? = nil) {
        self.commandID = commandID
        self.targetID = targetID
        self.issuerID = issuerID
        self.actions = actions

        self.actionResults = actionResults ?? []
        self.commandState = commandState ?? CommandState.sending
        self.firedByTriggerID = firedByTriggerID
        self.created = created
        self.modified = modified
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }

    /** Get actions associated with an alias.

     - Parameter alias: Alias to get action.
     - Returns Array of `AliasAction`.
     */
    open func getAction(_ alias: String) -> [AliasAction] {
        fatalError("TODO: implement me.")
    }

    open func isEqual(_ object: Any?) -> Bool {
        guard let aCommand = object as? Command else{
            return false
        }

        return self.commandID == aCommand.commandID &&
            self.targetID == aCommand.targetID &&
            self.issuerID == aCommand.issuerID
    }

    public static func == (left: Command, right: Command) -> Bool {
        return left.isEqual(right)
    }

    // TODO: We should replace this method with internal initializer.
    class func commandWithNSDictionary(_ nsDict: NSDictionary!) -> Command? {

        /*
        let commandID = nsDict["commandID"] as? String
        let schemaName = nsDict["schema"] as? String
        // actions array
        var actionsArray = [Dictionary<String, Any>]()
        if let actions = nsDict["actions"] as? [NSDictionary] {
            actionsArray = actions as! [Dictionary<String, Any>]
        }
        // actionResult array
        var actionsResultArray = [Dictionary<String, Any>]()
        if let actionResults = nsDict["actionResults"] as? [NSDictionary] {
            actionsResultArray = actionResults as! [Dictionary<String, Any>]
        }
        let schemaVersion = nsDict["schemaVersion"] as? Int

        var targetID: TypedID?
        if let targetString = nsDict["target"] as? String {
            var targetInfoArray = targetString.components(separatedBy: ":")
            if targetInfoArray.count == 2 {
                targetID = TypedID(type: targetInfoArray[0], id: targetInfoArray[1])
            }
        }

        var issuerID: TypedID?
        if let issureString = nsDict["issuer"] as? String {
            var issuerInfoArray = issureString.components(separatedBy: ":")
            if issuerInfoArray.count == 2 {
                issuerID = TypedID(type: issuerInfoArray[0], id: issuerInfoArray[1])
            }
        }

        var commandState: CommandState?
        if let commandStateString = nsDict["commandState"] as? String {
            switch commandStateString {
            case "SENDING":
                commandState = CommandState.sending
            case "DELIVERED":
                commandState = CommandState.delivered
            case "INCOMPLETE":
                commandState = CommandState.incomplete
            default:
                commandState = CommandState.done
            }
        }
        if targetID == nil || issuerID == nil || schemaName == nil || schemaVersion == nil {
            return nil
        }
        var created: Date? = nil
        if let createdAt = nsDict["createdAt"] as? NSNumber {
            created = Date(timeIntervalSince1970: (createdAt.doubleValue)/1000.0)
        }
        var modified: Date? = nil
        if let modifiedAt = nsDict["modifiedAt"] as? NSNumber {
            modified = Date(timeIntervalSince1970: (modifiedAt.doubleValue)/1000.0)
        }
        return Command(commandID: commandID, targetID: targetID!, issuerID: issuerID!, schemaName: schemaName!, schemaVersion: schemaVersion!, actions: actionsArray, actionResults: actionsResultArray, commandState: commandState, firedByTriggerID: nsDict["firedByTriggerID"] as? String, created: created, modified: modified, title: nsDict["title"] as? String, commandDescription: nsDict["description"] as? String, metadata: nsDict["metadata"] as? Dictionary<String, Any>)
        */
        return nil
    }
}

/** Enum represents state of the Command. */
public enum CommandState: Int {
    /* NOTE: These numbers must not be changed.
       These numbers are used serialization and deserialization
       If thses numbers are changed, then serialization and deserialization
       is broken. */
    /** SENDING Command */
    case sending = 1
    /** Command is published to the Target. */
    case delivered = 2
    /** Target returns execution result but not completed all actions successfully. */
    case incomplete = 3
    /** Target returns execution result and all actions successfully done. */
    case done = 4
}
