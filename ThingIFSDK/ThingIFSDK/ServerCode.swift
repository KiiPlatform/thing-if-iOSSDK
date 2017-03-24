//
//  ServerCode.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation
public struct ServerCode {

    // MARK: Properties
    /** Endpoint to call on servercode */
    public let endpoint: String
    /** This token will be used to call the external appID endpoint */
    public let executorAccessToken: String?
    /** If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used */
    public let targetAppID: String?
    /** Parameters to pass to the servercode function */
    public let parameters: [String : Any]?

    /** Init TriggeredServerCodeResult with necessary attributes

     - Parameter endpoint: Endpoint to call on servercode
     - Parameter executorAccessToken: This token will be used to call the external appID endpoint
     - Parameter targetAppID: If provided, servercode endpoint will be called for this appid. Otherwise same appID of trigger is used
     - Parameter parameters: Parameters to pass to the servercode function
     */
    public init(
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

extension ServerCode: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let endpoint = jsonObject["endpoint"] as? String else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          endpoint,
          executorAccessToken: jsonObject["executorAccessToken"] as? String,
          targetAppID: jsonObject["targetAppID"] as? String,
          parameters: jsonObject["parameters"] as? [String : Any])
    }

}
