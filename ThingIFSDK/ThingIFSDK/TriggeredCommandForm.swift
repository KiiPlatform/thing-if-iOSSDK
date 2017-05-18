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
public struct TriggeredCommandForm {

    // MARK: - Properties

    /// Array of AliasAction instances.
    public let aliasActions: [AliasAction]

    /// Target thing ID.
    public let targetID: TypedID?

    /// Title of a command.
    public let title: String?

    /// Description of a command.
    public let commandDescription: String?

    /// Meta data of ad command.
    public let metadata: [String : Any]?


    // MARK: - Initializing TriggeredCommandForm instance.
    /**
    Initializer of TriggeredCommandForm instance.

    - Parameter aliasActions: Array of AliasAction instances. Must not be empty.
    - Parameter targetID: target thing ID.
    - Parameter title: Title of a command. This should be equal or
      less than 50 characters.
    - Parameter description: Description of a comand. This should be
      equal or less than 200 characters.
    - Parameter metadata: Meta data of a command.
    */
    public init(_ aliasActions: [AliasAction],
                targetID: TypedID? = nil,
                title: String? = nil,
                commandDescription: String? = nil,
                metadata: [String : Any]? = nil)
    {
        self.aliasActions = aliasActions
        self.targetID = targetID
        self.title = title
        self.commandDescription = commandDescription
        self.metadata = metadata
    }
}

extension TriggeredCommandForm: ToJsonObject {

    internal func makeJsonObject() -> [String : Any] {
        var retval: [String : Any] =
          ["actions" : self.aliasActions.map { $0.makeJsonObject() }]
        retval["target"] = self.targetID?.toString()
        retval["title"] = self.title
        retval["description"] = self.commandDescription
        retval["metadata"] = self.metadata
        return retval
    }
}
