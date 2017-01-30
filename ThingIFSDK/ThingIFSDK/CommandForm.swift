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

  - Array of actions

Optional data are followings:

  - Title of a command
  - Description of a command
  - Meta data of a command
*/
open class CommandForm: NSCoding {

    // MARK: - Properties

    /// Array of actions.
    open let actions: [AliasAction]

    /// Title of a command.
    open let title: String?

    /// Description of a command.
    open let commandDescription: String?

    /// Meta data of ad command.
    open let metadata: [String : Any]?


    // MARK: - Initializing CommandForm instance.
    /**
    Initializer of CommandForm instance.

    - Parameter actions: Array of actions. Must not be empty.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(_ actions: [AliasAction],
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.actions = actions
        self.title = title;
        self.commandDescription = commandDescription;
        self.metadata = metadata;
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.actions, forKey: "actions")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.commandDescription,
                forKey: "commandDescription");
        aCoder.encode(self.metadata, forKey: "metadata")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          actions:aDecoder.decodeObject(forKey: "title") as! [AliasAction],
          title: aDecoder.decodeObject(forKey: "title") as? String,
          commandDescription: aDecoder.decodeObject(
            forKey: "commandDescription") as? String,
          metadata: aDecoder.decodeObject(
            forKey: "metadata")as? [String :  Any])
    }
}
