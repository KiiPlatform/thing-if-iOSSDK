//
//  OnboardWithThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class OnboardWithThingIDOptions {
    public let layoutPosition: LayoutPosition?
    public let dataGroupingInterval: DataGroupingInterval?

    /** Optional parameters of [ThingIFAPI onboard:thingID:thingPassword:options:completionHandler]
     - Parameter position GATEWAY | STANDALONE | ENDNODE.
     - Parameter interval: 1_MINUTE | 15_MINUTES | 30_MINUTES | 1_HOUR | 12_HOURS.
     Will be used to create the bucket to store the state history when the thing is not using traits.
     */
    public init(position: LayoutPosition?, interval: DataGroupingInterval?) {
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
