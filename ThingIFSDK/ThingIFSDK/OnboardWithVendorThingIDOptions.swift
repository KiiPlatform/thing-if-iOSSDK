//
//  OnboardWithVendorThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of
`ThingIFAPI.onboardWithVendorThingID(vendorThingID:thingPassword:options:completionHandler:)`.
*/
open class OnboardWithVendorThingIDOptions {
    open let thingType: String?
    open let firmwareVersion: String?
    open let thingProperties: Dictionary<String, Any>?
    open let layoutPosition: LayoutPosition?
    open let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter thingType: Type of the thing given by vendor.
      If the thing is already registered,
      this value would be ignored by IoT Cloud.
    - Parameter firmwareVersion: Firmware version of the thing.
    - Parameter thingProperties: The properties of the thing.
      You can set both the predefined and custom fields.
      Please read [here](https://docs.kii.com/en/starts/thingifsdk/thingsdk/management/#register-a-thing) for more details.
    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    - Parameter interval: interval1Minute | interval15Minutes | interval30Minutes | interval1Hour | interval12Hours.
      Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(
        thingType:String? = nil,
        firmwareVersion:String? = nil,
        thingProperties:Dictionary<String, Any>? = nil,
        position: LayoutPosition? = nil,
        interval: DataGroupingInterval? = nil)
    {
        self.thingType = thingType
        self.firmwareVersion = firmwareVersion
        self.thingProperties = thingProperties
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
