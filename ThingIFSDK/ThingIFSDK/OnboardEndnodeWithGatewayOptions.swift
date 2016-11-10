//
//  OnboardEndnodeWithGatewayOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of
`ThingIFAPI.onboardEndnodeWithGateway(pendingEndnode:endnodePassword:options:completionHandler:)`.
*/
open class OnboardEndnodeWithGatewayOptions {
    open let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter interval: interval1Minute | interval15Minutes | interval30Minutes | interval1Hour | interval12Hours.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(interval: DataGroupingInterval? = nil) {
        self.dataGroupingInterval = interval
    }
}
