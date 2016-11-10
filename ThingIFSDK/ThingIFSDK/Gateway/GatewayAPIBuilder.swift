//
//  GatewayAPIBuilder.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class GatewayAPIBuilder {

    private let tag: String?
    private let app: App
    private let gatewayAddress: URL

    /** Initialize builder.

     If you want to store GatewayAPI instance to storage, you need to
     set tag.

     tag is used to distinguish storage area of instance.  If the api
     instance is tagged with same string, It will be overwritten.  If
     the api instance is tagged with different string, Different key
     is used to store the instance.

     Please refer to `GatewayAPI.loadWithStoredInstance(_:)`

     - Parameter app: Kii Cloud Application.
     - Parameter gatewayAddress: address information for the gateway
     - Parameter tag: tag of the GatewayAPI instance. If null or empty
       String is passed, it will be ignored.
     */
    public init(app:App, address:URL, tag:String?=nil)
    {
        self.app = app
        self.gatewayAddress = address
        self.tag = tag
    }

    /** Make GatewayAPI instance.
    - Returns: GatewayAPI instance.
    */
    open func make() -> GatewayAPI
    {
        let api = GatewayAPI(app: self.app, gatewayAddress: self.gatewayAddress, tag: self.tag)
        return api
    }
}
