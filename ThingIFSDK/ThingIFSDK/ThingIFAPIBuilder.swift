//
//  ThingIFAPIBuilder.swift
//  ThingIFSDK
//

import Foundation

/** Builder class of ThingIFAPI */
open class ThingIFAPIBuilder {

    var app: App
    var owner: Owner
    var target: Target?
    var tag: String?

    /** Initialize builder.
    - Parameter app: Kii Cloud Application.
    - Parameter owner: Owner who consumes ThingIFAPI.
    - Parameter target: target of the ThingIFAPI instance.
    - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(app:App, owner:Owner, target: Target?=nil, tag:String?=nil) {
        self.app = app
        self.owner = owner
        self.target = target
        self.tag = tag
    }

    /** Make ThingIFAPI instance.
    - Returns: ThingIFAPI instance.
     */
    open func make() -> ThingIFAPI {
        let thingIFAPI = ThingIFAPI(app: self.app, owner: self.owner, tag: self.tag)
        thingIFAPI._target = self.target
        return thingIFAPI
    }
}
