//
//  GatewayAPI.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayAPI: NSObject, NSCoding {

    private static let SHARED_NSUSERDEFAULT_KEY_INSTANCE = "GatewayAPI_INSTANCE"
    private static func getSharedNSDefaultKey(tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }

    public let tag: String?
    public let app: App
    public let gatewayAddress: NSURL
    private var gatewayAddressString: String {
        return self.gatewayAddress.absoluteString!
    }

    private var accessToken: String?

    let operationQueue = OperationQueue()

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.tag, forKey: "tag")
        aCoder.encodeObject(self.app, forKey: "app")
        aCoder.encodeObject(self.gatewayAddress, forKey: "gatewayAddress")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.tag = aDecoder.decodeObjectForKey("tag") as? String
        self.app = aDecoder.decodeObjectForKey("app") as! App
        self.gatewayAddress = aDecoder.decodeObjectForKey("gatewayAddress") as! NSURL
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as? String
    }

    init(app: App, gatewayAddress: NSURL, tag: String? = nil)
    {
        self.tag = tag
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
        if username.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.UNSUPPORTED_ERROR)
            return
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/token"

        // generate header
        let credential = "\(self.app.appID):\(self.app.appKey)"

        let plainData = credential.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))

        let requestHeaderDict:Dictionary<String, String> = [
            "authorization": "Basic " + base64Str,
            "Content-Type": "application/json"
        ]

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "username": username,
                "password": password
            ]
        )

        do {
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.POST,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    self.accessToken = response?["accessToken"] as? String
                    self.saveInstance()
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.JSON_PARSE_ERROR)
        }
    }

    /** Let the Gateway Onboard.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is Gateway instance that has thingID asigned by Kii Cloud and 2nd one is an instance of ThingIFError when failed.
     */
    public func onboardGateway(
        completionHandler: (Gateway?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/onboarding"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.POST,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let gateway: Gateway?
                if response != nil {
                    let thingID = response!["thingID"] as? String
                    let vendorThingID = response!["vendorThingID"] as? String
                    gateway = Gateway(thingID: thingID!, vendorThingID: vendorThingID!)
                } else {
                    gateway = nil
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(gateway, error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Get Gateway ID

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Gateway ID and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayID(
        completionHandler: (String?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let thingID = response?["thingID"] as? String
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(thingID, error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** List connected end nodes which has been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is list of end nodes and 2nd one is an instance of ThingIFError when failed.
     */
    public func listOnboardedEndNodes(
        completionHandler: ([EndNode]?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/onboarded"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                var endNodes = [EndNode]()
                if response != nil {
                    if let endNodeArray = response!["results"] as? [NSDictionary] {
                        for endNode in endNodeArray {
                            let thingID = endNode["thingID"] as? String
                            let vendorThingID = endNode["vendorThingID"] as? String
                            endNodes.append(EndNode(thingID: thingID!, vendorThingID: vendorThingID!))
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    if error != nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(endNodes, nil)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** List connected end nodes which has not been onboarded.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is list of end nodes connected to the gateway but waiting for onboarding and 2nd one is an instance of ThingIFError when failed.
     */
    public func listPendingEndNodes(
        completionHandler: ([PendingEndNode]?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/pending"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                var endNodes = [PendingEndNode]()
                if response != nil {
                    if let endNodeArray = response!["results"] as? [NSDictionary] {
                        for endNode in endNodeArray {
                            endNodes.append(PendingEndNode(json: endNode as! Dictionary<String, AnyObject>))
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    if error != nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(endNodes, nil)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
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
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        if endNode.thingID.isEmpty || endNode.vendorThingID.isEmpty {
            completionHandler(ThingIFError.UNSUPPORTED_ERROR)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/VENDOR_THING_ID:\(endNode.vendorThingID)"

        // generate header
        var requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()
        requestHeaderDict["Content-Type"] = "application/json"

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "thingID": endNode.thingID
            ]
        )

        do {
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.JSON_PARSE_ERROR)
        }
    }

    /** Restore the Gateway.
     This API can be used only for the Gateway App.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    public func restore(
        completionHandler: (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/gateway-app/gateway/restore"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.POST,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
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
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        if endNodeThingID.isEmpty || endNodeVendorThingID.isEmpty {
            completionHandler(ThingIFError.UNSUPPORTED_ERROR)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/apps/\(self.app.appID)/gateway/end-nodes/THING_ID:\(endNodeThingID)"

        // generate header
        var requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()
        requestHeaderDict["Content-Type"] = "application/json"

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "vendorThingID": endNodeVendorThingID
            ]
        )

        do {
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.JSON_PARSE_ERROR)
        }
    }

    /** Get information of the Gateway.
     When the end user replaces the Gateway, Gateway App/End Node App need to obtain the new Gateway’s vendorThingID.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is information of the Gateway and 2nd one is an instance of ThingIFError when failed.
     */
    public func getGatewayInformation(
        completionHandler: (GatewayInformation?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.USER_IS_NOT_LOGGED_IN)
            return;
        }

        let requestURL = "\(self.gatewayAddressString)/gateway-info"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = generateAuthBearerHeader()

        // do request
        let request = buildNewRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let id = response?["vendorThingID"] as? String
                dispatch_async(dispatch_get_main_queue()) {
                    if id == nil {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(GatewayInformation(vendorThingID: id!), error)
                    }
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Check if user is logged in to the Gateway.

     - Returns: true if user is logged in, false otherwise.
     */
    public func isLoggedIn() -> Bool
    {
        return !(self.accessToken?.isEmpty ?? true)
    }

    /** Get Access Token

     - Returns: Access token
     */
    public func getAccessToken() -> String?
    {
        return self.accessToken
    }

    /** Try to load the instance of GatewayAPI using stored serialized instance.

     - Parameter tag: tag of the GatewayAPI instance
     - Returns: GatewayIFAPI instance.
     */
    public static func loadWithStoredInstance(tag : String? = nil) throws -> GatewayAPI?
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = GatewayAPI.getSharedNSDefaultKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary {
            if dict.objectForKey(key) != nil {
                if let data = dict[key] as? NSData {
                    if let savedAPI = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GatewayAPI {
                        return savedAPI
                    } else {
                        throw ThingIFError.INVALID_STORED_API
                    }
                } else {
                    throw ThingIFError.INVALID_STORED_API
                }
            } else {
                throw ThingIFError.API_NOT_STORED
            }
        } else {
            throw ThingIFError.API_NOT_STORED
        }
    }

    /** Clear all saved instances in the NSUserDefaults.
     */
    public static func removeAllStoredInstances()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        NSUserDefaults.standardUserDefaults().removeObjectForKey(baseKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the GatewayAPI instance or nil for default tag
     */
    public static func removeStoredInstances(tag : String?=nil)
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = GatewayAPI.getSharedNSDefaultKey(tag)
        if let tempdict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObjectForKey(key)
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: baseKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    /** Save this instance
     This method use NSUserDefaults. Should not use the key "GatewayAPI_INSTANCE", this key is reserved.
     */
    public func saveInstance()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let key = GatewayAPI.getSharedNSDefaultKey(self.tag)
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)

        if let tempdict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[key] = data
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: baseKey)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    private func generateAuthBearerHeader() -> Dictionary<String, String> {
        return [ "authorization": "Bearer \(self.accessToken!)" ]
    }
}
