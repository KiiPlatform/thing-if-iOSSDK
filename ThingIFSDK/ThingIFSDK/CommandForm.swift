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
`ThingIFAPI.postNewCommand(commandForm:completionHandler:)`.

Mandatory data are followings:

  - Schema name
  - Schema version
  - List of actions

Optional data are followings:

  - Title of a schema
  - Description of a schema
  - Meta data of a schema
*/
open class CommandForm: NSObject, NSCoding {

    // MARK: - Properties

    /// Schema name.
    open let schemaName: String

    /// Schema version.
    open let schemaVersion: Int

    /// List of actions.
    open let actions: [Dictionary<String, Any>]

    /// Title of a command.
    open let title: String?

    /// Description of a command.
    open let commandDescription: String?

    /// Meta data of ad command.
    open let metadata: Dictionary<String, Any>?


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
                actions: [Dictionary<String, Any>],
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: Dictionary<String, Any>? = nil)
    {
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
        self.title = title;
        self.commandDescription = commandDescription;
        self.metadata = metadata;
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.schemaName, forKey: "schemaName")
        aCoder.encode(self.schemaVersion, forKey: "schemaVersion")
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription,
                forKey: "commandDescription");
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    public required init?(coder aDecoder: NSCoder) {
        self.schemaName = aDecoder.decodeObject(forKey: "schemaName") as! String
        self.schemaVersion = aDecoder.decodeInteger(forKey: "schemaVersion")
        self.actions = aDecoder.decodeObject(forKey: "actions")
                as! [Dictionary<String, Any>];
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.commandDescription =
            aDecoder.decodeObject(forKey: "commandDescription") as? String;
        self.metadata = aDecoder.decodeObject(forKey: "metadata")
                as? Dictionary<String, Any>;
    }
}
