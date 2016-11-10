//
//  OnboardWithThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of
`ThingIFAPI.onboardWithThingID(thingID:thingPassword:options:completionHandler:)`.
*/
open class OnboardWithThingIDOptions {
    open let layoutPosition: LayoutPosition?
    open let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    - Parameter interval: interval1Minute | interval15Minutes | interval30Minutes | interval1Hour | interval12Hours.
     Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(position: LayoutPosition? = nil, interval: DataGroupingInterval? = nil) {
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
