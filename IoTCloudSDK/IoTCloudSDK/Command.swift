//
//  Command.swift
//  IoTCloudSDK
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
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        self.commandID = aDecoder.decodeObjectForKey("commandID") as! String
        self.targetID = aDecoder.decodeObjectForKey("targetID") as! TypedID
        self.issuerID = aDecoder.decodeObjectForKey("issuerID") as! TypedID
        self.schemaName = aDecoder.decodeObjectForKey("schemaName") as! String
        self.schemaVersion = aDecoder.decodeIntegerForKey("schemaVersion")
        self.actions = []
        self.actionResults = []
        self.commandState = CommandState.SENDING
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
    public let actions: [Dictionary<String, Any>]

    /** Results of the action. */
    public let actionResults: [Dictionary<String, Any>]

    /** State of the Command. */
    public let commandState: CommandState

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
    }
    public init(commandID: String, targetID: TypedID, issuerID: TypedID, schemaName: String, schemaVersion: Int, actions:[Dictionary<String, Any>], actionResults:[Dictionary<String, Any>]?, commandState: CommandState?) {
        self.commandID = commandID
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

    public class func commandWithNSDictionary(nsDict: NSDictionary!) -> Command?{

        let commandID = nsDict["commandID"] as? String
        let schemaName = nsDict["schema"] as? String
        // actions array
        var actionsArray = [Dictionary<String, Any>]()
        if let actions = nsDict["actions"] as? [NSDictionary] {
            for nsdict in actions {
                var actionsDict = Dictionary<String, Any>()
                for(key, value) in nsdict {
                    actionsDict[key as! String] = value
                }
                actionsArray.append(actionsDict)
            }
        }
        // actionResult array
        var actionsResultArray = [Dictionary<String, Any>]()
        if let actionResults = nsDict["actionResults"] as? [NSDictionary] {
            for nsdict in actionResults {
                var actionResultsDict = Dictionary<String, Any>()
                for(key, value) in nsdict {
                    actionResultsDict[key as! String] = value
                }
                actionsResultArray.append(actionResultsDict)
            }
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
        if ((targetID != nil) || (issuerID != nil) || (schemaName != nil)) || (schemaVersion != nil)
            || (commandID != nil) {
                command = Command(commandID: commandID!, targetID: targetID!, issuerID: issuerID!, schemaName: schemaName!, schemaVersion: schemaVersion!, actions: actionsArray, actionResults: actionsResultArray, commandState: commandState)
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