//
//  GatewayAPI.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayAPI: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement me.
    }

    public required init(coder aDecoder: NSCoder){
        // TODO: implement me.
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
        comletionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Let the Gateway Onboard.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func onboardGateway(
        comletionHandler: (String?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Get Gateway ID

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Gateway ID and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayID(
        comletionHandler: (String?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** List connected end nodes which has not been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is List of end nodes connected to the gateway but waiting for onboarding and 2nd one is an instance of ThingIFError when failed.
     */
    public func listPendingEndNodes(
        comletionHandler: ([PendingEndNode]?, ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Notify Onboarding completion
     Call this api when the End Node onboarding is done.
     After the call succeeded, End Node will be fully connected to Kii Cloud through the Gateway.

     - Parameter endNodeThingID: ID of the end-node assigned by Kii Cloud.
     - Parameter endNodeVendorThingID: ID of the end-node assigned by End Node vendor.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func notifyOnboardingCompletion(
        endNodeThingID: String,
        endNodeVendorThingID: String,
        comletionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Restore the Gateway

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func retore(
        comletionHandler: (ThingIFError?)-> Void
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
        comletionHandler: (ThingIFError?)-> Void
        )
    {
        // TODO: implement me.
    }

    /** Get vendorThingID of the Gateway.
     When the end user replaces the Gateway, Gateway App/End Node App need to obtain the new Gateway’s vendorThingID.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is vendorThingID of the Gateway and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayInformation(
        comletionHandler: (String?, ThingIFError?)-> Void
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

    /** Get a tag.

     - Returns: tag
     */
    public func getTag() -> String?
    {
        // TODO: implement me.
        return nil
    }

    /** Get Kii App

     - Returns: Kii Cloud Application.
     */
    public func getApp() -> App
    {
        // TODO: implement me.
        return App(appID: "dummy", appKey: "dummy", site: Site.JP)
    }

    /** Get AppID

     - Returns: Application ID
     */
    public func getAppID() -> String
    {
        // TODO: implement me.
        return "dummy"
    }

    /** Get AppKey

     - Returns: Application key
     */
    public func getAppKey() -> String
    {
        // TODO: implement me.
        return "dummy"
    }

    /** Get GatewayAddress

     - Returns: Gateway Address
     */
    public func getGatewayAddress() -> GatewayAddress
    {
        // TODO: implement me.
        return GatewayAddress(hostName: "dummy")
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
    public static func loadWithStoredInstance(tag : String? = nil) throws -> ThingIFAPI?
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
     */
    public func saveInstance()
    {
        // TODO: implement me.
    }
}