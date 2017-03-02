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
