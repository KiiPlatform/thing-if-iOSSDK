//
//  OnboardWithVendorThingIDOptions.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Optional parameters of [ThingIFAPI.onboard(_:thingPassword:options:completionHandler)](./ThingIFAPI.html#/s:FC10ThingIFSDK10ThingIFAPI7onboardFS0_FTSS13thingPasswordSS7optionsGSqCS_31OnboardWithVendorThingIDOptions_17completionHandlerFTGSqPS_6Target__GSqOS_12ThingIFError__T__T_).
 */
public class OnboardWithVendorThingIDOptions {
    public let thingType: String?
    public let thingProperties: Dictionary<String,AnyObject>?
    public let layoutPosition: LayoutPosition?
    public let dataGroupingInterval: DataGroupingInterval?

    /** initializer.

    - Parameter thingType: Type of the thing given by vendor.
      If the thing is already registered,
      this value would be ignored by IoT Cloud.
    - Parameter thingProperties: Properties of thing.
      If the thing is already registered, this value would be ignored by IoT Cloud.
      Refer to the [REST API DOC](http://docs.kii.com/rest/#thing_management-register_a_thing)
      About the format of this Document.
    - Parameter position: GATEWAY | STANDALONE | ENDNODE.
    - Parameter interval: 1_MINUTE | 15_MINUTES | 30_MINUTES | 1_HOUR | 12_HOURS.
      Will be used to create the bucket to store the state history when the thing is not using traits.
    */
    public init(
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        position: LayoutPosition?,
        interval: DataGroupingInterval?)
    {
        self.thingType = thingType
        self.thingProperties = thingProperties
        self.layoutPosition = position
        self.dataGroupingInterval = interval
    }
}
