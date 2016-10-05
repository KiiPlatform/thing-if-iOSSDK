//
//  ServerCode.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
public class ServerCode : NSObject, NSCoding {
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.endpoint, forKey: "endpoint")
        aCoder.encodeObject(self.executorAccessToken, forKey: "executorAccessToken")
        aCoder.encodeObject(self.targetAppID, forKey: "targetAppID")
        aCoder.encodeObject(self.parameters, forKey: "parameters")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.endpoint = aDecoder.decodeObjectForKey("endpoint") as! String
        self.executorAccessToken = aDecoder.decodeObjectForKey("executorAccessToken") as? String
        self.targetAppID = aDecoder.decodeObjectForKey("targetAppID") as? String
        self.parameters = aDecoder.decodeObjectForKey("parameters") as? Dictionary<String, AnyObject>
    }

    /** Endpoint to call on servercode */
    public let endpoint: String
    /** This token will be used to call the external appID endpoint */
    public let executorAccessToken: String?
    /** If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used */
    public let targetAppID: String?
    /** Parameters to pass to the servercode function */
    public let parameters: Dictionary<String, AnyObject>?

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

    public override func isEqual(object: AnyObject?) -> Bool {
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
            NSDictionary(dictionary: self.parameters!).isEqualToDictionary(aServerCode.parameters!)

    }

    class func serverCodeWithNSDictionary(nsDict: NSDictionary!) -> ServerCode?{
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
