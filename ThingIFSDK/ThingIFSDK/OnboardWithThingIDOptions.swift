//
//  OnboardWithThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of `ThingIFAPI.onboardWithThingID(_:thingPassword:options:completionHandler:)`.
*/
public class OnboardWithThingIDOptions {
    public let layoutPosition: LayoutPosition?
    public let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    - Parameter interval: INTERVAL_1_MINUTE | INTERVAL_15_MINUTES | INTERVAL_30_MINUTES | INTERVAL_1_HOUR | INTERVAL_12_HOURS.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(position: LayoutPosition? = nil, interval: DataGroupingInterval? = nil) {
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
