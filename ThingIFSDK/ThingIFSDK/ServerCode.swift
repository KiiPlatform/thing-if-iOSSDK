//
//  ServerCode.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright 2016 Kii. All rights reserved.
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
    public required init?(coder aDecoder: NSCoder) {
        self.endpoint = aDecoder.decodeObject(forKey: "endpoint") as! String
        self.executorAccessToken = aDecoder.decodeObject(forKey: "executorAccessToken") as? String
        self.targetAppID = aDecoder.decodeObject(forKey: "targetAppID") as? String
        self.parameters = aDecoder.decodeObject(forKey: "parameters") as? [String : Any]
    }

    /** Endpoint to call on servercode */
    open let endpoint: String
    /** This token will be used to call the external appID endpoint */
    open let executorAccessToken: String?
    /** If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used */
    open let targetAppID: String?
    /** Parameters to pass to the servercode function */
    open let parameters: [String : Any]?

    /** Init TriggeredServerCodeResult with necessary attributes

     - Parameter endpoint: Endpoint to call on servercode
     - Parameter executorAccessToken: This token will be used to call the external appID endpoint
     - Parameter targetAppID: If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used
     - Parameter parameters: Parameters to pass to the servercode function
     */
    internal init(
      _ endpoint: String,
      executorAccessToken: String? = nil,
      targetAppID: String? = nil,
      parameters: [String : Any]? = nil)
    {
        self.endpoint = endpoint
        self.executorAccessToken = executorAccessToken
        self.targetAppID = targetAppID
        self.parameters = parameters
    }

}
