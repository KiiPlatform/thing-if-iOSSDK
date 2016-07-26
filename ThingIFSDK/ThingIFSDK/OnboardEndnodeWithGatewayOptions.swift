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

    - Parameter interval: 1_MINUTE | 15_MINUTES | 30_MINUTES | 1_HOUR | 12_HOURS.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(interval: DataGroupingInterval?) {
        self.dataGroupingInterval = interval
    }
}
