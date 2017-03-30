//
//  ThingIFAPI+Push.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation


extension ThingIFAPI {

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT
     Cloud.  IoT Cloud will send notification when the Target replies
     to the Command.  Application can receive the notification and
     check the result of Command fired by Application or registered
     Trigger.  After installation is done Installation ID is managed
     in this class.

     - Parameter deviceToken: Data instance of device token for APNS.
     - Parameter development: Bool flag indicate whether the cert is
       development or production. This is optional, the default is
       false (production).
     - Parameter completionHandler: A closure to be executed once on
       board has finished.
     */
    open func installPush(
        _ deviceToken:Data,
        development:Bool=false,
        completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {

        let requestURL = "\(baseURL)/api/apps/\(appID)/installations"

        let requestBody : [String:Any] = [
            "installationRegistrationID":deviceToken.hexString(),
            "deviceType":"IOS",
            "development":development
        ]

        self.operationQueue.addHttpRequestOperation(
            .post,
            url: requestURL,
            requestHeader:
            self.defaultHeader + ["Content-Type" : MediaType.mediaTypeThingPushInstallationRequest.rawValue],
            requestBody: requestBody,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                if let installationID = response?["installationID"] as? String{
                    self.installationID = installationID
                }
                self.saveToUserDefault()
                DispatchQueue.main.async {
                    completionHandler(self.installationID, error)
                }
        }
    }

    /** Uninstall push notification.
     After done, notification from IoT Cloud won't be notified.

     - Parameter installationID: installation ID returned from
       installPush(). If null is specified, value of the
       installationID property is used.
     */
    open func uninstallPush(
        _ installationID: String? = nil,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        guard let installationID = installationID ?? self.installationID else {
            completionHandler(ThingIFError.unsupportedError)
            return
        }
        let requestURL = "\(baseURL)/api/apps/\(appID)/installations/\(installationID)"

        self.operationQueue.addHttpRequestOperation(
            .delete,
            url: requestURL,
            requestHeader:
            self.defaultHeader,
            failureBeforeExecutionHandler: { completionHandler($0) }) {
            response, error in

            if error == nil && self.installationID == installationID {
                self.installationID = nil
            }
            self.saveToUserDefault()
            DispatchQueue.main.async {
                completionHandler( error)
            }
        }

    }

}
