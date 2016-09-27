//
//  TriggeredCommandForm.swift
//  ThingIFSDK
//
//  Created on 2016/09/26.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

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

    // MARK: - Properties

    /// Schema name.
    private var schemaName: String

    /// Schema version.
    private var schemaVersion: Int

    /// List of actions.
    private var actions: [Dictionary<String, AnyObject>]

    /// Target thing ID.
    private var targetID: TypedID?

    /// Title of a command.
    private var title: String?

    /// Description of a command.
    private var commandDescription: String?

    /// Meta data of ad command.
    private var metadata: Dictionary<String, AnyObject>?

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

    public func getSchemaName() -> String {
        return self.schemaName;
    }

    public func setSchemaName(
            schemaName: String) -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func getSchemaVersion() -> Int {
        return self.schemaVersion;
    }

    public func setSchemaVersion(
            schemaVersion: Int) -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func getActions() -> [Dictionary<String, AnyObject>] {
        return self.actions;
    }

    public func setActions(
            actions: [Dictionary<String, AnyObject>])
        -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func getTargetID() -> TypedID? {
        return self.targetID;
    }

    public func setTargetID(targetID: TypedID?) -> TriggeredCommandFormBuilder {
        // TODO: implement me.
        return self;
    }

    public func getTitle() -> String? {
        return self.title;
    }

    public func setTitle(title: String?) -> TriggeredCommandFormBuilder {
        // TODO: implement me.
        return self;
    }

    public func getCommandDescription() -> String? {
        return self.commandDescription;
    }

    public func setCommandDescription(
            commandDescription: String?)
        -> TriggeredCommandFormBuilder
    {
        // TODO: implement me.
        return self;
    }

    public func getMetadata() -> Dictionary<String, AnyObject>? {
        return self.metadata;
    }

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
