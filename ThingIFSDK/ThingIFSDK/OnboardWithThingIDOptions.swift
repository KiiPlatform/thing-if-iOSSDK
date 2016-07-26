//
//  OnboardWithThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of [ThingIFAPI.onboard(_:thingPassword:options:completionHandler)](./ThingIFAPI.html#/s:FC10ThingIFSDK10ThingIFAPI7onboardFS0_FTSS13thingPasswordSS7optionsGSqCS_25OnboardWithThingIDOptions_17completionHandlerFTGSqPS_6Target__GSqOS_12ThingIFError__T__T_).
*/
public class OnboardWithThingIDOptions {
    public let layoutPosition: LayoutPosition?
    public let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    - Parameter interval: INTERVAL_1_MINUTE | INTERVAL_15_MINUTES | INTERVAL_30_MINUTES | INTERVAL_1_HOUR | INTERVAL_12_HOURS.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(position: LayoutPosition?, interval: DataGroupingInterval?) {
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
