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

extension OnboardWithThingIDOptions: JsonObjectCompatible {

    internal init(_ jsonObject: [String : Any]) throws {
        // This method may not use so this method is not tested.
        // If you want to use this method, please test this.

        let position: LayoutPosition?
        if let layoutPosition = jsonObject["layoutPosition"] as? String {
            position = LayoutPosition(rawValue: layoutPosition)
        } else {
            position = nil
        }
        self.init(position)
    }

    internal func makeJsonObject() -> [String : Any]{
        if let layoutPosition = self.layoutPosition {
            return [ "layoutPosition" : layoutPosition.rawValue ]
        }
        return [ : ]
    }
}
