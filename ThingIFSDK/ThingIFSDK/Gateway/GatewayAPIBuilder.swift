//
//  GatewayAPIBuilder.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayAPIBuilder {

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
        // TODO: implement me.
        return self
    }

    /** Initialize builder.
     - Parameter app: Kii Cloud Application.
     - Parameter gatewayAddress: address information for the gateway
     - Parameter tag: tag of the GatewayAPI instance.
     */
    public init(app:App, address:GatewayAddress, tag:String?=nil)
    {
        // TODO: implement me.
    }

    /** Build GatewayAPI instance.
    - Returns: GatewayAPI instance.
    */
    public func build() -> GatewayAPI
    {
        // TODO: implement me.
        // NOTE: this method must not return nil, this return is dummy.
        return nil
    }
}
