//
//  GatewayAPI.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class GatewayAPI: NSObject, NSCoding {

    private static let SHARED_NSUSERDEFAULT_KEY_INSTANCE = "GatewayAPI_INSTANCE"
    private static func getSharedNSDefaultKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }

    open let tag: String?
    open let app: App
    open let gatewayAddress: URL
    private var gatewayAddressString: String {
        return self.gatewayAddress.absoluteString
    }

    private var accessToken: String?

    let operationQueue = OperationQueue()

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.tag, forKey: "tag")
        aCoder.encode(self.app, forKey: "app")
        aCoder.encode(self.gatewayAddress, forKey: "gatewayAddress")
        aCoder.encode(self.accessToken, forKey: "accessToken")
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.tag = aDecoder.decodeObject(forKey: "tag") as? String
        self.app = aDecoder.decodeObject(forKey: "app") as! App
        self.gatewayAddress = aDecoder.decodeObject(forKey: "gatewayAddress") as! URL
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
    }

    init(app: App, gatewayAddress: URL, tag: String? = nil)
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
    open func login(
        _ username: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if username.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return
        }

        let requestURL = "\(self.gatewayAddressString)/\(self.app.siteName)/token"

        // generate header
        let credential = "\(self.app.appID):\(self.app.appKey)"

        let plainData = credential.data(using: String.Encoding.utf8)!
        let base64Str = plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))

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
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.POST,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    self.accessToken = response?["accessToken"] as? String
                    self.saveInstance()
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.jsonParseError)
        }
    }

    /** Let the Gateway Onboard.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is Gateway instance that has thingID asigned by Kii Cloud and 2nd one is an instance of ThingIFError when failed.
     */
    open func onboardGateway(
        _ completionHandler: @escaping (Gateway?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func getGatewayID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func listOnboardedEndNodes(
        _ completionHandler: @escaping ([EndNode]?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func listPendingEndNodes(
        _ completionHandler: @escaping ([PendingEndNode]?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func notifyOnboardingCompletion(
        _ endNode: EndNode,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
            return;
        }

        if endNode.thingID.isEmpty || endNode.vendorThingID.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
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
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.jsonParseError)
        }
    }

    /** Restore the Gateway.
     This API can be used only for the Gateway App.

     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func restore(
        _ completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func replaceEndNode(
        _ endNodeThingID: String,
        endNodeVendorThingID: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(ThingIFError.userIsNotLoggedIn)
            return;
        }

        if endNodeThingID.isEmpty || endNodeVendorThingID.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
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
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildNewRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.jsonParseError)
        }
    }

    /** Get information of the Gateway.
     When the end user replaces the Gateway, Gateway App/End Node App need to obtain the new Gateway’s vendorThingID.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is information of the Gateway and 2nd one is an instance of ThingIFError when failed.
     */
    open func getGatewayInformation(
        _ completionHandler: @escaping (GatewayInformation?, ThingIFError?)-> Void
        )
    {
        if !self.isLoggedIn() {
            completionHandler(nil, ThingIFError.userIsNotLoggedIn)
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
                DispatchQueue.main.async {
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
    open func isLoggedIn() -> Bool
    {
        return !(self.accessToken?.isEmpty ?? true)
    }

    /** Get Access Token

     - Returns: Access token
     */
    open func getAccessToken() -> String?
    {
        return self.accessToken
    }

    /** Try to load the instance of GatewayAPI using stored serialized instance.

     - Parameter tag: tag of the GatewayAPI instance
     - Returns: GatewayIFAPI instance.
     */
    open static func loadWithStoredInstance(_ tag : String? = nil) throws -> GatewayAPI?
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = GatewayAPI.getSharedNSDefaultKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            if dict.object(forKey: key) != nil {
                if let data = dict[key] as? Data {
                    if let savedAPI = NSKeyedUnarchiver.unarchiveObject(with: data) as? GatewayAPI {
                        return savedAPI
                    } else {
                        throw ThingIFError.invalidStoredApi
                    }
                } else {
                    throw ThingIFError.invalidStoredApi
                }
            } else {
                throw ThingIFError.apiNotStored
            }
        } else {
            throw ThingIFError.apiNotStored
        }
    }

    /** Clear all saved instances in the NSUserDefaults.
     */
    open static func removeAllStoredInstances()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        UserDefaults.standard.removeObject(forKey: baseKey)
        UserDefaults.standard.synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the GatewayAPI instance or nil for default tag
     */
    open static func removeStoredInstances(_ tag : String?=nil)
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = GatewayAPI.getSharedNSDefaultKey(tag)
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObject(forKey: key)
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }
    }

    /** Save this instance
     This method use NSUserDefaults. Should not use the key "GatewayAPI_INSTANCE", this key is reserved.
     */
    open func saveInstance()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let key = GatewayAPI.getSharedNSDefaultKey(self.tag)
        let data = NSKeyedArchiver.archivedData(withRootObject: self)

        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[key] = data
            UserDefaults.standard.set(dict, forKey: baseKey)
        } else {
            UserDefaults.standard.set(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        UserDefaults.standard.synchronize()
    }

    private func generateAuthBearerHeader() -> Dictionary<String, String> {
        return [ "authorization": "Bearer \(self.accessToken!)" ]
    }
}
