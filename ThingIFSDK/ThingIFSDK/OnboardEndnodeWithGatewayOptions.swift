//
//  OnboardEndnodeWithGatewayOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of `ThingIFAPI.onboardEndnodeWithGateway(_:endnodePassword:options:completionHandler:)`.
 */
public class OnboardEndnodeWithGatewayOptions {
    public let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter interval: INTERVAL_1_MINUTE | INTERVAL_15_MINUTES | INTERVAL_30_MINUTES | INTERVAL_1_HOUR | INTERVAL_12_HOURS.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(interval: DataGroupingInterval? = nil) {
        self.dataGroupingInterval = interval
    }
}
