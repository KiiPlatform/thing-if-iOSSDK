//
//  ThingIFAPI.swift
//  ThingIFSDK
//

import Foundation

/** Class provides API of the ThingIF. */
open class ThingIFAPI: Equatable {

    /** Tag of the ThingIFAPI instance */
    open let tag : String?

    internal let operationQueue = OperationQueue()
    /** URL of KiiApps Server */
    open var baseURL: String {
        get {
            return self.app.baseURL
        }
    }
    /** The application ID found in your Kii developer console */
    open var appID: String {
        get {
            return self.app.appID
        }
    }
    /** The application key found in your Kii developer console */
    open var appKey: String {
        get {
            return self.app.appKey
        }
    }
    /** Kii Cloud Application */
    open let app: KiiApp
    /** owner of target */
    open let owner: Owner


    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.

    - Returns: Installation ID used in IoT Cloud.
    */
    open internal(set) var installationID: String?

    /** target */
    open internal(set) var target: Target?

    /** Checks whether on boarding is done. */
    open var onboarded: Bool {
        get {
            return self.target != nil
        }
    }

    /** Initialize `ThingIFAPI` instance.

     - Parameter app: Kii Cloud Application.
     - Parameter owner: Owner who consumes ThingIFAPI.
     - Parameter target: target of the ThingIFAPI instance.
     - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(
      _ app: KiiApp,
      owner: Owner,
      target: Target? = nil,
      tag : String? = nil)
    {
        self.app = app
        self.owner = owner
        self.target = target
        self.tag = tag
    }

    public static func == (left: ThingIFAPI, right: ThingIFAPI) -> Bool {
        return left.appID == right.appID &&
          left.appKey == right.appKey &&
          left.baseURL == right.baseURL &&
          left.target?.accessToken == right.target?.accessToken &&
          left.target?.typedID == right.target?.typedID &&
          left.installationID == right.installationID &&
          left.tag == right.tag
    }

}

internal extension ThingIFAPI {

    var defaultHeader: [String : String] {
        get {
            return [
              "Authorization" : "Bearer \(self.owner.accessToken)",
              "X-Kii-AppID" : self.appID,
              "X-Kii-AppKey" : self.appKey,
              "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
            ]
        }
    }
}
