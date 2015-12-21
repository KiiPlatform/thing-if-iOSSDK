//
//  ThingIFAPIBuilder.swift
//  ThingIFSDK
//

import Foundation

/** Builder class of ThingIFAPI */
public class ThingIFAPIBuilder {

    var thingIFAPI: ThingIFAPI!

    /** Initialize builder.
    - Parameter app: Kii Cloud Application.
    - Parameter owner: Owner who consumes ThingIFAPI.
    - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(app:App, owner:Owner, tag:String?=nil) {
        thingIFAPI = ThingIFAPI(app: app, owner: owner, tag: tag)
    }
    /** Build ThingIFAPI instance.
    - Returns: ThingIFAPI instance.
     */
    public func build() -> ThingIFAPI {
        return thingIFAPI
    }
}