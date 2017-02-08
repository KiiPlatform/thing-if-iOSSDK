//
//  OnboardWithVendorThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of
`ThingIFAPI.onboardWith(vendorThingID:thingPassword:options:completionHandler:)`.
*/
open class OnboardWithVendorThingIDOptions {
    open let thingType: String?
    open let firmwareVersion: String?
    open let thingProperties: Dictionary<String, Any>?
    open let layoutPosition: LayoutPosition?

    /** initializer.

    - Parameter thingType: Type of the thing given by vendor.
      If the thing is already registered,
      this value would be ignored by IoT Cloud.
    - Parameter firmwareVersion: Firmware version of the thing.
    - Parameter thingProperties: The properties of the thing.
      You can set both the predefined and custom fields.
      Please read [here](https://docs.kii.com/en/starts/thingifsdk/thingsdk/management/#register-a-thing) for more details.
    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    */
    public init(
        _ thingType:String? = nil,
        firmwareVersion:String? = nil,
        thingProperties:Dictionary<String, Any>? = nil,
        position: LayoutPosition? = nil)
    {
        self.thingType = thingType
        self.firmwareVersion = firmwareVersion
        self.thingProperties = thingProperties
        self.layoutPosition = position
    }
}
