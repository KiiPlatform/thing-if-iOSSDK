//
//  Command.swift
//  ThingIFSDK
//
import Foundation

/** Class represents Command */
public struct Command {

    // MARK: Properties
    /** ID of the Command. */
    public let commandID: String
    /** ID of the Command Target. */
    public let targetID: TypedID
    /** ID of the issuer of the Command. */
    public let issuerID: TypedID
    /** Actions to be executed. */
    public let aliasActions: [AliasAction]
    /** Results of the action. */
    public let aliasActionResults: [AliasActionResult]
    /** State of the Command. */
    public let commandState: CommandState
    /** ID of the trigger which fired this command. */
    public let firedByTriggerID: String?
    /** Creation time of the Command.*/
    public let created: Date?
    /** Modification time of the Command. */
    public let modified: Date?
    /** Title of the Command */
    public let title: String?
    /** Description of the Command */
    public let commandDescription: String?
    /** Metadata of the Command */
    public let metadata: [String : Any]?

    /** Initialize `Command`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameter commandID: ID of the Command.
     - Parameter issuerID: ID of the issuer of the Command.
     - Parameter targetID: ID of the Command Target.
     - Parameter aliasActions: Array of actions. Must not be empty.
     - Parameter aliasActionResults: Results of the action.
     - Parameter commandState: State of the Command.
     - Parameter firedByTriggerID: ID of the trigger which fired this
       command.
     - Parameter created: Creation time of the Command.
     - Parameter modified: Modification time of the Command.
     - Parameter title: Title of a command. This should be equal or
       less than 50 characters.
     - Parameter commandDescription: Description of a comand. This
       should be equal or less than 200 characters.
     - Parameter metadata: Meta data of a command.
     */
    public init(_ commandID: String,
         targetID: TypedID,
         issuerID: TypedID,
         aliasActions: [AliasAction],
         aliasActionResults: [AliasActionResult] = [],
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
        self.aliasActions = aliasActions

        self.aliasActionResults = aliasActionResults
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
    public func getAliasAction(_ alias: String) -> [AliasAction] {
        return self.aliasActions.filter { $0.alias == alias }
    }

    /** Get action results associated with an alias and action name.

     - Parameter alias: Alias to get action result.
     - Parameter alias: Action name to get action result.
     - Returns Array of `AliasAction`.
     */
    public func getActionResult(
      _ alias: String,
      actionName: String) -> [ActionResult]
    {
        var retval: [ActionResult] = []
        for results in self.aliasActionResults.filter({ $0.alias == alias }) {
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
