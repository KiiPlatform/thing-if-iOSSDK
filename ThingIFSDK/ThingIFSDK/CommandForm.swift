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
public class CommandForm: NSObject {

    internal let schemaName: String
    internal let schemaVersion: Int
    internal let actions: [Dictionary<String, AnyObject>]
    private var title: String?

    // MARK: - Properties
    public var desc: String?
    public var metadata: [Dictionary<String, AnyObject>]?

    // MARK: - Initializing CommandForm instance.
    /**
    Initializer of CommandForm instance.

    - Parameter schemaName: Schema name
    - Parameter schemaVersion: Schema version
    - Parameter actions: List of actions. Must not be empty.
    - Throws: `ThingIFError.InvalidArgument` if actions is empty.
    */
    public init(schemaName: String,
                schemaVersion: Int,
                actions: [Dictionary<String, AnyObject>]) throws
    {
        // TODO: implement me.
        self.schemaName = schemaName
        self.schemaVersion = schemaVersion
        self.actions = actions
    }

    // MARK: - Methods
    /**
    Setter of a title.

    Title must equal or be less than 50 characters. Title also must
    not be empty string.

    If title is nil, title is not applied to a command.

    - Parameter title: Title of a command. Must not be more thant 50 characters.
    - Throws: `ThingIFError.InvalidArgument` if title is more
        than 50 characters.
    */
    public func setTitle(title: String?) throws -> Void {
        // TODO: implement me.
    }

    /**
    Getter of a title.

    - Returns: Title of a command.
    */
    public func getTitle() -> String? {
        return nil
    }
}
