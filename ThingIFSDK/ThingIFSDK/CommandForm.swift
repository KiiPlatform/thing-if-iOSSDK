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
public struct CommandForm {

    // MARK: - Properties

    /// Array of AliasAction instances.
    public let aliasActions: [AliasAction]

    /// Title of a command.
    public let title: String?

    /// Description of a command.
    public let commandDescription: String?

    /// Meta data of ad command.
    public let metadata: [String : Any]?


    // MARK: - Initializing CommandForm instance.
    /**
    Initializer of CommandForm instance.

    - Parameter actions: Array of AliasAction instances. Must not be empty.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(_ aliasActions: [AliasAction],
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.aliasActions = aliasActions
        self.title = title;
        self.commandDescription = commandDescription;
        self.metadata = metadata;
    }

}
