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

     - Parameter completionHandler: A closure to be executed once get
       id has finished. The closure takes 2 arguments: 1st one is
       Vendor Thing ID and 2nd one is an instance of ThingIFError when
       failed.
     */
    open func getVendorThingID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        ) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        // do request
        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(self.baseURL)/api/apps/\(self.appID)/things/\(target.typedID.id)/vendor-thing-id",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in
            let result = convertResponse(response, error) {
                json, error -> (String?, ThingIFError?) in

                if error != nil {
                    return (nil, error)
                }
                return (response?["_vendorThingID"] as? String, nil)
            }
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }

    /** Update the Vendor Thing ID of specified Target.

     - Parameter vendorThingID: New vendor thing id
     - Parameter password: New password
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func update(
        vendorThingID: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }
        if vendorThingID.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)",
            "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
        ]

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "_vendorThingID": vendorThingID,
                "_password": password
            ]
        )

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(
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

}
