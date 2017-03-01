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

 - `ThingIFAPI.postNewTrigger(_:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(_:triggeredCommandForm:predicate:options:completionHandler:)`

Mandatory data are followings:

  - Array of actions

Optional data are followings:

  - Target thing id
  - Title of a triggered command
  - Description of a triggered command
  - Meta data of a triggered command
*/
open class TriggeredCommandForm {

    // MARK: - Properties

    /// Array of actions.
    open let actions: [AliasAction]

    /// Target thing ID.
    open let targetID: TypedID?

    /// Title of a command.
    open let title: String?

    /// Description of a command.
    open let commandDescription: String?

    /// Meta data of ad command.
    open let metadata: [String : Any]?


    // MARK: - Initializing TriggeredCommandForm instance.
    /**
    Initializer of TriggeredCommandForm instance.

    - Parameter actions: Array of actions. Must not be empty.
    - Parameter targetID: target thing ID.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(_ actions: [AliasAction],
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.actions = actions
        self.targetID = targetID
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }

    /**
    Initializer of TriggeredCommandForm instance.

    This initializer copies following fields:

    - `Command.actions`
    - `Command.targetID`
    - `Command.title`
    - `Command.commandDescription`
    - `Command.metadata`

    If you specify optional arguments corresponding to above mentioned
    value, Optional argument values win against the `Command` values.

    - Parameter command: source command of this TriggeredCommandForm.
    - Parameter actions: Array of actions. Must not be empty.
    - Parameter targetID: target thing ID.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    /*
     TODO: We consider in order to remove or not this method.
     Because we may not craete TriggeredCommandForm from Command.
    public init(command: Command,
                actions: [AliasAction]? = nil,
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.actions = actions ?? command.actions
        self.targetID = targetID ?? command.targetID
        self.title = title ?? command.title
        self.commandDescription =
          commandDescription ?? command.commandDescription
        self.metadata = metadata ?? command.metadata
    }
    */

    func toDictionary() -> Dictionary<String, Any> {
        var retval: [String : Any] =
            [
                "actions": self.actions
            ]

        retval["target"] = self.targetID?.toString()
        retval["title"] = self.title
        retval["description"] = self.commandDescription
        retval["metadata"] = self.metadata
        return retval;
    }
}
