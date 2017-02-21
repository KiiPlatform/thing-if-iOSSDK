//
//  OnboardWithThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of
`ThingIFAPI.onboardWith(thingID:thingPassword:options:completionHandler:)`.
*/
open class OnboardWithThingIDOptions {
    open let layoutPosition: LayoutPosition?

    /** initializer.

    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    */
    public init(_ position: LayoutPosition? = nil) {
        self.layoutPosition = position
    }
}
