//
//  HistoryState.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** History of state. */
public struct HistoryState {

    /** State of a target thing. */
    public let state: [String : Any]
    /** Creation time of a state. */
    public let createdAt: Date

    /** Initialize `HistoryState`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters state: State of a target thing.
     - Parameters createdAt: Creation time of a state.
     */
    public init(_ state: [String: Any], createdAt: Date) {
        self.state = state
        self.createdAt = createdAt
    }

}

extension HistoryState : FromJsonObject {
    internal init(_ jsonObject: [String : Any]) throws {
        var state = jsonObject
        guard let created = state["_created"] as? Int64 else {
            throw ThingIFError.jsonParseError
        }

        state.removeValue(forKey: "_created")
        self.init(
            state,
            createdAt: Date(timeIntervalSince1970InMillis: created))
    }
}
