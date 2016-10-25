//
//  ServerCode.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
open class ServerCode : NSObject, NSCoding {
    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.endpoint, forKey: "endpoint")
        aCoder.encode(self.executorAccessToken, forKey: "executorAccessToken")
        aCoder.encode(self.targetAppID, forKey: "targetAppID")
        aCoder.encode(self.parameters, forKey: "parameters")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.endpoint = aDecoder.decodeObject(forKey: "endpoint") as! String
        self.executorAccessToken = aDecoder.decodeObject(forKey: "executorAccessToken") as? String
        self.targetAppID = aDecoder.decodeObject(forKey: "targetAppID") as? String
        self.parameters = aDecoder.decodeObject(forKey: "parameters") as? Dictionary<String, AnyObject>
    }

    /** Endpoint to call on servercode */
    open let endpoint: String
    /** This token will be used to call the external appID endpoint */
    open let executorAccessToken: String?
    /** If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used */
    open let targetAppID: String?
    /** Parameters to pass to the servercode function */
    open let parameters: Dictionary<String, AnyObject>?

    /** Init TriggeredServerCodeResult with necessary attributes

     - Parameter endpoint: Endpoint to call on servercode
     - Parameter executorAccessToken: This token will be used to call the external appID endpoint
     - Parameter targetAppID: If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used
     - Parameter parameters: Parameters to pass to the servercode function
     */
    public init(endpoint: String, executorAccessToken: String?, targetAppID: String?, parameters: Dictionary<String, AnyObject>?) {
        self.endpoint = endpoint
        self.executorAccessToken = executorAccessToken
        self.targetAppID = targetAppID
        self.parameters = parameters
    }

    func toNSDictionary() -> NSDictionary {
        let dict = NSMutableDictionary(dictionary: ["endpoint": self.endpoint])
        if self.executorAccessToken != nil {
            dict["executorAccessToken"] = self.executorAccessToken
        }
        if self.targetAppID != nil {
            dict["targetAppID"] = self.targetAppID
        }
        if self.parameters != nil {
            dict["parameters"] = self.parameters
        }
        return dict
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let aServerCode = object as? ServerCode else{
            return false
        }
        if self.parameters == nil || aServerCode.parameters == nil {
            if self.parameters == nil && aServerCode.parameters == nil {
                return true
            }
            return false
        }
        return self.endpoint == aServerCode.endpoint &&
            self.executorAccessToken == aServerCode.executorAccessToken &&
            self.targetAppID == aServerCode.targetAppID &&
            NSDictionary(dictionary: self.parameters!).isEqual(to: aServerCode.parameters!)

    }

    class func serverCodeWithNSDictionary(_ nsDict: NSDictionary!) -> ServerCode?{
        let endpoint = nsDict["endpoint"] as? String
        let executorAccessToken = nsDict["executorAccessToken"] as? String
        let targetAppID = nsDict["targetAppID"] as? String
        let parameters = nsDict["parameters"] as? Dictionary<String, AnyObject>
        var serverCode: ServerCode?
        if (endpoint != nil) {
            serverCode = ServerCode(endpoint:endpoint!, executorAccessToken:executorAccessToken, targetAppID:targetAppID, parameters:parameters)
        }
        return serverCode
    }
    
}
