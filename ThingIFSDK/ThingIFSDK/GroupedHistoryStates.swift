//
//  GroupedHistoryStates.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Grouped history states. */
public struct GroupedHistoryStates {

    /** Time range of this states. */
    public let timeRange: TimeRange
    /** Result objects. */
    public let objects: [HistoryState]

    /** Initialize `GroupedHistoryStates`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters timeRange: Time range of this states.
     - Parameters objects: Result objects.
     */
    public init(_ timeRange: TimeRange, objects: [HistoryState]) {
        self.timeRange = timeRange
        self.objects = objects
    }

}
