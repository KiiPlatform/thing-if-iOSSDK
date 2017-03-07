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
public struct OnboardWithThingIDOptions {
    public let layoutPosition: LayoutPosition?

    /** initializer.

    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    */
    public init(_ position: LayoutPosition? = nil) {
        self.layoutPosition = position
    }
}

extension OnboardWithThingIDOptions: JsonObjectSerializable {

    internal func makeJson() -> [String : Any]{
        if let layoutPosition = self.layoutPosition {
            return [ "layoutPosition" : layoutPosition.rawValue ]
        }
        return [ : ]
    }
}
