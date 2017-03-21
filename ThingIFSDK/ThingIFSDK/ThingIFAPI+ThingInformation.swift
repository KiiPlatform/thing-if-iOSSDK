//
//  ThingIFAPI+ThingInformation.swift
//  ThingIFSDK
//
//  Created on 2017/03/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    // MARK: - Thing information methods

    /** Get the Vendor Thing ID of specified Target.

     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Vendor Thing ID and 2nd one is an instance of ThingIFError when failed.
     */
    open func getVendorThingID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)"
        ]

        // do request
        let request = buildDefaultRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let vendorThingID = response?["_vendorThingID"] as? String
                DispatchQueue.main.async {
                    completionHandler(vendorThingID, error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

}
