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
public struct OnboardWithVendorThingIDOptions {
    public let thingType: String?
    public let firmwareVersion: String?
    public let thingProperties: [String : Any]?
    public let layoutPosition: LayoutPosition?

    /** initializer.

    - Parameter thingType: Type of the thing given by vendor.
      If the thing is already registered,
      this value would be ignored by IoT Cloud.
    - Parameter firmwareVersion: Firmware version of the thing.
    - Parameter thingProperties: The properties of the thing.  You can
      set both the predefined and custom fields. thingProperties must
      be JSON compatible. Please read
      [here](https://docs.kii.com/en/starts/thingifsdk/thingsdk/management/#register-a-thing)
      for more details.
    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    */
    public init(
        _ thingType: String? = nil,
        firmwareVersion: String? = nil,
        thingProperties: [String : Any]? = nil,
        position: LayoutPosition? = nil)
    {
        self.thingType = thingType
        self.firmwareVersion = firmwareVersion
        self.thingProperties = thingProperties
        self.layoutPosition = position
    }
}

extension OnboardWithVendorThingIDOptions: JsonObjectCompatible {

    internal init(_ jsonObject: [String : Any]) throws {
        // This method may not use so this method is not tested.
        // If you want to use this method, please test this.

        let position: LayoutPosition?
        if let layoutPosition = jsonObject["layoutPosition"] as? String {
            position = LayoutPosition(rawValue: layoutPosition)
        } else {
            position = nil
        }
        self.init(
          jsonObject["thingType"] as? String,
          firmwareVersion: jsonObject["firmwareVersion"] as? String,
          thingProperties: jsonObject["thingProperties"] as? [String : Any],
          position: position)
    }

    internal func makeJsonObject() -> [String : Any]{
        var retval: [String : Any] = [ : ]
        retval["thingType"] = self.thingType
        retval["firmwareVersion"] = self.firmwareVersion
        retval["thingProperties"] = self.thingProperties
        retval["layoutPosition"] = self.layoutPosition?.rawValue
        return retval
    }
}
