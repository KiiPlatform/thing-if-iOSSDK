//
//  Command.swift
//  IoTCloudSDK
//
import Foundation

/** Class represents Command */
public class Command {

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
    public let actions: [Dictionary<String, Any>]

    /** Results of the action. */
    public let actionResults: [Dictionary<String, Any>]

    /** State of the Command. */
    public let commandState: CommandState

    public init() {
        // TODO: implement it with proper initilizer.
        self.commandID = ""
        self.targetID = TypedID(type: "", id: "")
        self.issuerID = TypedID(type: "", id: "")
        self.schemaName = ""
        self.schemaVersion = 0
        self.actions = []
        self.actionResults = []
        self.commandState = CommandState.SENDING
    }
}

/** Enum represents state of the Command. */
public enum CommandState {
    /** SENDING Command */
    case SENDING
    /** Command is published to the Target. */
    case DELIVERED
    /** Target returns execution result but not completed all actions successfully. */
    case IMCOMPLETE
    /** Target returns execution result and all actions successfully done. */
    case DONE
}