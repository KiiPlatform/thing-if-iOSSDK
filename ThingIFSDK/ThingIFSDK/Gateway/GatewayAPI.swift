//
//  GatewayAPI.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayAPI: NSObject, NSCoding {

    public let tag: String?
    public let app: App
    public let gatewayAddress: NSURL

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        // TODO: implement me.
    }

    public required init(coder aDecoder: NSCoder)
    {
        // TODO: implement me.
        self.tag = nil
        self.app = App(appID: "dummy", appKey: "dummy", site: Site.JP)
        self.gatewayAddress = NSURL()
    }

    init(app: App, gatewayAddress: NSURL)
    {
        // TODO: implement me.
        self.tag = nil
        self.app = app
        self.gatewayAddress = gatewayAddress
    }

    // MARK: API methods

    /** Login to the Gateway.
     Local authentication for the Gateway access.
     Required prior to call other APIs access to the gateway.

     - Parameter username: Username of the Gateway.
     - Parameter password: Password of the Gateway.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func login(
        username: String,
        password: String,
        completionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Let the Gateway Onboard.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is Gateway instance that has thingID asigned by Kii Cloud and 2nd one is an instance of ThingIFError when failed.
     */
    public func onboardGateway(
        completionHandler: (Gateway?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Get Gateway ID

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Gateway ID and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayID(
        completionHandler: (String?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** List connected end nodes which has not been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is List of end nodes connected to the gateway but waiting for onboarding and 2nd one is an instance of ThingIFError when failed.
     */
    public func listPendingEndNodes(
        completionHandler: ([PendingEndNode]?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Notify Onboarding completion
     Call this api when the End Node onboarding is done.
     After the call succeeded, End Node will be fully connected to Kii Cloud through the Gateway.

     - Parameter endNode: Onboarded EndNode
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func notifyOnboardingCompletion(
        endNode: EndNode,
        completionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Restore the Gateway.
     This API can be used only for the Gateway App.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func retore(
        completionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Replace end-node by new vendorThingID for end node thingID.

     - Parameter endNodeThingID: ID of the end-node assigned by Kii Cloud.
     - Parameter endNodeVendorThingID: ID of the end-node assigned by End Node vendor.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func replaceEndNode(
        endNodeThingID: String,
        endNodeVendorThingID: String,
        completionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Get information of the Gateway.
     When the end user replaces the Gateway, Gateway App/End Node App need to obtain the new Gateway’s vendorThingID.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is information of the Gateway and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayInformation(
        completionHandler: (GatewayInformation?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Check if user is logged in to the Gateway.

     - Returns: true if user is logged in, false otherwise.
     */
    public func isLoggedIn() -> Bool
    {
        // TODO: implement me.
        return false
    }

    /** Get Access Token

     - Returns: Access token
     */
    public func getAccessToken() -> String?
    {
        // TODO: implement me.
        return nil
    }

    /** Try to load the instance of GatewayAPI using stored serialized instance.

     - Parameter tag: tag of the GatewayAPI instance
     - Returns: GatewayIFAPI instance.
     */
    public static func loadWithStoredInstance(tag : String? = nil) throws -> GatewayAPI?
    {
        // TODO: implement me.
        return nil
    }

    /** Clear all saved instances in the NSUserDefaults.
     */
    public static func removeAllStoredInstances()
    {
        // TODO: implement me.
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the GatewayAPI instance or nil for default tag
     */
    public static func removeStoredInstances(tag : String?=nil)
    {
        // TODO: implement me.
    }

    /** Save this instance
     This method use NSUserDefaults. Should not use the key "GatewayAPI_INSTANCE", this key is reserved.
     */
    public func saveInstance()
    {
        // TODO: implement me.
    }
}
