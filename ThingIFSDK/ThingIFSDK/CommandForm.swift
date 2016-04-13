//
//  CommandForm.swift
//  ThingIFSDK
//
//  Created on 2016/04/04.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
Form of a command.

This class contains data in order to create `Command` with
`ThingIFAPI.postNewCommand(_:completionHandler:)`.

Mandatory data are followings:

  - Schema name
  - Schema version
  - List of actions

Optional data are followings:

  - Title of a schema
  - Description of a schema
  - Meta data of a schema
*/
public class CommandForm: NSObject, NSCoding {

    // MARK: - Properties

    /// Schema name.
    public let schemaName: String

    /// Schema version.
    public let schemaVersion: Int

    /// List of actions.
    public let actions: [Dictionary<String, AnyObject>]

    /// Title of a command.
    public let title: String?

    /// Description of a command.
    public let commandDescription: String?

    /// Meta data of ad command.
    public let metadata: Dictionary<String, AnyObject>?


    // MARK: - Initializing CommandForm instance.
    /**
    Initializer of CommandForm instance.

    - Parameter schemaName: Schema name.
    - Parameter schemaVersion: Schema version.
    - Parameter actions: List of actions. Must not be empty.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(schemaName: String,
                schemaVersion: Int,
                actions: [Dictionary<String, AnyObject>],
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: Dictionary<String, AnyObject>? = nil)
    {
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
        self.title = title;
        self.commandDescription = commandDescription;
        self.metadata = metadata;
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.schemaName, forKey: "schemaName")
        aCoder.encodeInteger(self.schemaVersion, forKey: "schemaVersion")
        aCoder.encodeObject(self.actions, forKey: "actions")
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
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.commandDescription =
            aDecoder.decodeObjectForKey("commandDescription") as? String;
        self.metadata = aDecoder.decodeObjectForKey("metadata")
                as? Dictionary<String, AnyObject>;
    }
}
