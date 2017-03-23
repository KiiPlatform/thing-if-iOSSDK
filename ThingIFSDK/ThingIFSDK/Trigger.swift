//
//  Trigger.swift
//  ThingIFSDK
//

import Foundation

/** Class represents Trigger */
public struct Trigger {

    public var triggersWhat: TriggersWhat? {
        get {
            if self.command != nil {
                return TriggersWhat.command
            } else if self.serverCode != nil {
                return TriggersWhat.serverCode
            } else {
                return nil
            }
        }
    }

    /** ID of the Trigger */
    public let triggerID: String
    /** ID of the Trigger target */
    public let targetID: TypedID
    /** Flag indicate whether the Trigger is enabled */
    public let enabled: Bool
    /** Predicate of the Trigger */
    public let predicate: Predicate
    /** Command to be fired */
    public let command: Command?
    /** ServerCode to be fired */
    public let serverCode: ServerCode?
    /** Title of the Trigger */
    public let title: String?
    /** Description of the Trigger */
    public let triggerDescription: String?
    /** Metadata of the Trigger */
    public let metadata: Dictionary<String, Any>?

    /** Init Trigger with Command

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

    - Parameter triggerID: ID of trigger
    - Parameter targetID: ID of trigger target
    - Parameter enabled: True to enable trigger
    - Parameter predicate: Predicate instance
    - Parameter command: Command instance
    - Parameter title: Title of a trigger. This should be equal or
      less than 50 characters.
    - Parameter triggerDescription: Description of a trigger. This
      should be equal or less than 200 characters.
    - Parameter metadata: Meta data of a trigger.
    */
    public init(
      _ triggerID: String,
      targetID: TypedID,
      enabled: Bool,
      predicate: Predicate,
      command: Command,
      title: String? = nil,
      triggerDescription: String? = nil,
      metadata: Dictionary<String, Any>? = nil)
    {
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

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameter triggerID: ID of trigger
     - Parameter targetID: ID of trigger target
     - Parameter enabled: True to enable trigger
     - Parameter predicate: Predicate instance
     - Parameter serverCode: ServerCode instance
     - Parameter title: Title of a trigger. This should be equal or
       less than 50 characters.
     - Parameter triggerDescription: Description of a trigger. This
       should be equal or less than 200 characters.
     - Parameter metadata: Meta data of a trigger.
     */
    public init(
      _ triggerID: String,
      targetID: TypedID,
      enabled: Bool,
      predicate: Predicate,
      serverCode: ServerCode,
      title: String? = nil,
      triggerDescription: String? = nil,
      metadata: Dictionary<String, Any>? = nil)
    {
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
    case command = "COMMAND"
    case serverCode = "SERVER_CODE"
}

public enum EventSource: String {
    /* NOTE: These string values must not be changed. These values are
       used serialization and deserialization If thses values are
       changed, then serialization and deserialization is broken. */

    case states = "STATES"
    case schedule = "SCHEDULE"
    case scheduleOnce = "SCHEDULE_ONCE"

}

extension Trigger: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let triggerID = jsonObject["triggerID"] as? String,
              let predicateDict = jsonObject["predicate"] as? [String : Any],
              let disabled = jsonObject["disabled"] as? Bool else {
            throw ThingIFError.jsonParseError
        }

        let targetID = try TypedID(jsonObject["target"] as? String)
        let predicate = try makePredicate(predicateDict)

        let title = jsonObject["title"] as? String
        let description = jsonObject["description"] as? String
        let metadata = jsonObject["metadata"] as? [String : Any]

        if let command = jsonObject["command"] as? [String : Any] {
            self.init(
              triggerID,
              targetID: targetID,
              enabled: !disabled,
              predicate: predicate,
              command: try Command(command),
              title: title,
              triggerDescription: description,
              metadata: metadata)
        } else if let serverCode = jsonObject["serverCode"] as? [String : Any] {
            self.init(
              triggerID,
              targetID: targetID,
              enabled: !disabled,
              predicate: predicate,
              serverCode: try ServerCode(serverCode),
              title: title,
              triggerDescription: description,
              metadata: metadata)
        } else {
            throw ThingIFError.jsonParseError
        }
    }

}
