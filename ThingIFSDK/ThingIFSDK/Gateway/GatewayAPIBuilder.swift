//
//  GatewayAPIBuilder.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayAPIBuilder {

    private var tag: String?
    private let app: App
    private let gatewayAddress: NSURL
    public var accessToken: String?

    /** Set tag to this GatewayAPI instance.
     tag is used to distinguish storage area of instance.
     <br>
     If the api instance is tagged with same string, It will be overwritten.
     <br>
     If the api instance is tagged with different string, Different key is used to store the instance.
     <br>
     <br>
     Please refer to {@link GatewayAPI#loadFromStoredInstance(Context, String)} as well.

     - Parameter tag: If null or empty String us passed, it will be ignored.
     - Returns: builder instance for chaining call.
     */
    public func setTag(tag: String?) -> GatewayAPIBuilder
    {
        self.tag = tag
        return self
    }

    /** Initialize builder.
     - Parameter app: Kii Cloud Application.
     - Parameter gatewayAddress: address information for the gateway
     - Parameter tag: tag of the GatewayAPI instance.
     */
    public init(app:App, address:NSURL, tag:String?=nil)
    {
        self.app = app
        self.gatewayAddress = address
        self.tag = tag
    }

    /** Build GatewayAPI instance.
    - Returns: GatewayAPI instance.
    */
    public func build() -> GatewayAPI
    {
        let api = GatewayAPI(app: self.app, gatewayAddress: self.gatewayAddress, tag: self.tag)
        api.accessToken = self.accessToken
        return api
    }
}
