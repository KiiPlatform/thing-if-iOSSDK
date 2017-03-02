//
//  Command.swift
//  ThingIFSDK
//
import Foundation

/** Class represents Command */
open class Command: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.commandID, forKey: "commandID")
        aCoder.encode(self.targetID, forKey: "targetID")
        aCoder.encode(self.issuerID, forKey: "issuerID")
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.actionResults, forKey: "actionResults")
        aCoder.encode(self.commandState.rawValue, forKey: "commandState")
        aCoder.encode(self.firedByTriggerID, forKey: "firedByTriggerID")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.modified, forKey: "modified")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription, forKey: "commandDescription")
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    // MARK: - Implements NSCoding protocol
    public required init?(coder aDecoder: NSCoder) {
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
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.modified = aDecoder.decodeObject(forKey: "modified") as? Date
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.commandDescription = aDecoder.decodeObject(forKey: "commandDescription") as? String
        self.metadata = aDecoder.decodeObject(forKey: "metadata") as? [String : Any]
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
    open let metadata: [String : Any]?

    internal init(_ commandID: String,
         targetID: TypedID,
         issuerID: TypedID,
         actions: [AliasAction],
         actionResults: [AliasActionResult] = [],
         commandState: CommandState = .sending,
         firedByTriggerID: String? = nil,
         created: Date? = nil,
         modified: Date? = nil,
         title: String? = nil,
         commandDescription: String? = nil,
         metadata: [String : Any]? = nil) {
        self.commandID = commandID
        self.targetID = targetID
        self.issuerID = issuerID
        self.actions = actions

        self.actionResults = actionResults
        self.commandState = commandState
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
        return self.actions.filter { $0.alias == alias }
    }

    /** Get action results associated with an alias and action name.

     - Parameter alias: Alias to get action result.
     - Parameter alias: Action name to get action result.
     - Returns Array of `AliasAction`.
     */
    open func getActionResult(
      _ alias: String,
      actionName: String) -> [ActionResult]
    {
        var retval: [ActionResult] = []
        for results in self.actionResults.filter({ $0.alias == alias }) {
            retval += results.results.filter { $0.actionName == actionName }
        }
        return retval
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
