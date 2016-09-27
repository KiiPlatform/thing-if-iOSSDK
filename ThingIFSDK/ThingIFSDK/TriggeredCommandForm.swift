//
//  TriggeredCommandForm.swift
//  ThingIFSDK
//
//  Created on 2016/09/26.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
Form of a command of a trigger.

This class contains data in order to create or modify `Command` in
`Trigger` with followings methods:

 - `ThingIFAPI.postNewTrigger(form:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(triggerID:form:predicate:options:completionHandler:)`

Mandatory data are followings:

  - Schema name
  - Schema version
  - List of actions

Optional data are followings:

  - Target thing id
  - Title of a schema
  - Description of a schema
  - Meta data of a schema
*/
public class TriggeredCommandForm: NSObject, NSCoding {

    // MARK: - Properties

    /// Schema name.
    public let schemaName: String

    /// Schema version.
    public let schemaVersion: Int

    /// List of actions.
    public let actions: [Dictionary<String, AnyObject>]

    /// Target thing ID.
    public let targetID: TypedID?

    /// Title of a command.
    public let title: String?

    /// Description of a command.
    public let commandDescription: String?

    /// Meta data of ad command.
    public let metadata: Dictionary<String, AnyObject>?


    private init(schemaName: String,
                schemaVersion: Int,
                actions: [Dictionary<String, AnyObject>],
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: Dictionary<String, AnyObject>? = nil)
    {
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
        self.targetID = targetID
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.schemaName, forKey: "schemaName")
        aCoder.encodeInteger(self.schemaVersion, forKey: "schemaVersion")
        aCoder.encodeObject(self.actions, forKey: "actions")
        aCoder.encodeObject(self.targetID, forKey: "typedID")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.commandDescription,
                forKey: "commandDescription");
        aCoder.encodeObject(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.schemaName = aDecoder.decodeObjectForKey("schemaName") as! String
        self.schemaVersion = aDecoder.decodeIntegerForKey("schemaVersion")
        self.actions = aDecoder.decodeObjectForKey("actions")
                as! [Dictionary<String, AnyObject>];
        self.targetID = aDecoder.decodeObjectForKey("targetID") as? TypedID
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.commandDescription =
            aDecoder.decodeObjectForKey("commandDescription") as? String;
        self.metadata = aDecoder.decodeObjectForKey("metadata")
                as? Dictionary<String, AnyObject>;
    }
}

public class TriggeredCommandFormBuilder: NSObject, NSCoding {

    private var schemaName: String
    private var schemaVersion: Int
    private var actions: [Dictionary<String, AnyObject>]
    private var targetID: TypedID?
    private var title: String?
    private var commandDescription: String?
    private var metadata: Dictionary<String, AnyObject>?

    // MARK: - Initializing TriggeredCommandFormBuilder instance.
    /**
    Initializer of TriggeredCommandFormBuilder instance.

    - Parameter schemaName: Schema name.
    - Parameter schemaVersion: Schema version.
    - Parameter actions: List of actions. Must not be empty.
    - Parameter targetID: target thing ID.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(schemaName: String,
                schemaVersion: Int,
                actions: [Dictionary<String, AnyObject>],
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: Dictionary<String, AnyObject>? = nil)
    {
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
        self.targetID = targetID
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }

    /**
    Build `TriggeredCommandForm` instance.

    - Returns: `TriggeredCommandForm` instance
    */
    public func build() -> TriggeredCommandForm {
        return TriggeredCommandForm(
                schemaName: self.schemaName,
                schemaVersion: self.schemaVersion,
                actions: self.actions,
                targetID: self.targetID,
                title: self.title,
                commandDescription: self.commandDescription,
                metadata: self.metadata)
    }

    /** Getter of schema name of this triggered command.

    - Returns: schema name of this triggered command.
    */
    public func getSchemaName() -> String {
        return self.schemaName;
    }

    /** Setter of schema name of this triggered command.

    - Parameter: schemaName: schema name.
    - Returns: this instance to chain.
    */
    public func setSchemaName(
            schemaName: String) -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    /** Getter of schema version of this triggered command.

    - Returns: schema version of this triggered command.
    */
    public func getSchemaVersion() -> Int {
        return self.schemaVersion;
    }

    /** Setter of schema version of this triggered command.

    - Parameter: schemaVersion: schema version.
    - Returns: this instance to chain.
    */
    public func setSchemaVersion(
            schemaVersion: Int) -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    /** Getter of actions of this triggered command.

    - Returns: actions of this triggered command.
    */
    public func getActions() -> [Dictionary<String, AnyObject>] {
        return self.actions;
    }

    /** Setter of actions of this triggered command.

    - Parameter: actions: actions.
    - Returns: this instance to chain.
    */
    public func setActions(
            actions: [Dictionary<String, AnyObject>])
        -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    /** Getter of target thing ID of this command in trigger.

    - Returns: target thing ID of this command in trigger.
    */
    public func getTargetID() -> TypedID? {
        return self.targetID;
    }

    /**
    Setter of target thing ID of this command in trigger.

    `ThingIFAPI.postNewTrigger(form:predicate:options:completionHandler:)`
    and
    `ThingIFAPI.patchTrigger(triggerID:form:predicate:options:completionHandler:)`
    uses `TriggeredCommandForm.targetID` to specify target of a
    command in trigger. If you do not set target thing ID with this
    method, default target is used. The default target is
    'ThingIFAPI.target`.

    If you create trigger which target of command is not default
    target, and update trigger with `TriggeredCommandForm.targetID` as
    nil, then, command target of updated trigger is changed to default
    target.

    - Parameter: targetID: target thing ID.
    - Returns: this instance to chain.
    */
    public func setTargetID(targetID: TypedID?) -> TriggeredCommandFormBuilder {
        // TODO: implement me.
        return self;
    }

    /** Getter of title of this command in trigger.

    - Returns: title of this command in trigger.
    */
    public func getTitle() -> String? {
        return self.title;
    }

    /** Setter of title of this command in trigger.

    - Parameter title: title, This should be equal or less than 50 characters.
    - Returns: this instance to chain.
    */
    public func setTitle(title: String?) -> TriggeredCommandFormBuilder {
        // TODO: implement me.
        return self;
    }

    /** Getter of description of this command in trigger.

    - Returns: description of this command in trigger.
    */
    public func getCommandDescription() -> String? {
        return self.commandDescription;
    }

    /** Setter of description of this command in trigger.

    - Parameter description: description, This should be equal or less
      than 200 characters.
    - Returns: this instance to chain.
    */
    public func setCommandDescription(
            commandDescription: String?)
        -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    /** Getter of metadata of this command in trigger.

    - Returns: metadata of this command in trigger.
    */
    public func getMetadata() -> Dictionary<String, AnyObject>? {
        return self.metadata;
    }

    /** Setter of metadata of this command in trigger.

    - Parameter metadata: metadata
    - Returns: this instance to chain.
    */
    public func setMetadata(
            metadata: Dictionary<String, AnyObject>?)
        -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.schemaName, forKey: "schemaName")
        aCoder.encodeInteger(self.schemaVersion, forKey: "schemaVersion")
        aCoder.encodeObject(self.actions, forKey: "actions")
        aCoder.encodeObject(self.targetID, forKey: "typedID")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.commandDescription,
                forKey: "commandDescription");
        aCoder.encodeObject(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.schemaName = aDecoder.decodeObjectForKey("schemaName") as! String
        self.schemaVersion = aDecoder.decodeIntegerForKey("schemaVersion")
        self.actions = aDecoder.decodeObjectForKey("actions")
                as! [Dictionary<String, AnyObject>];
        self.targetID = aDecoder.decodeObjectForKey("targetID") as? TypedID
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.commandDescription =
            aDecoder.decodeObjectForKey("commandDescription") as? String;
        self.metadata = aDecoder.decodeObjectForKey("metadata")
                as? Dictionary<String, AnyObject>;
    }

}
