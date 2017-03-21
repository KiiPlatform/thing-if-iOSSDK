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
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 1 argument: an instance of
       ThingIFError when failed.
     */
    open func update(
        vendorThingID: String,
        password: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        guard let target = self.target else {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }
        if vendorThingID.isEmpty || password.isEmpty {
            completionHandler(ThingIFError.unsupportedError)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .put,
          url: "\(self.baseURL)/api/apps/\(self.appID)/things/\(target.typedID.id)/vendor-thing-id",
          requestHeader:
            self.defaultHeader +
            [
              "Content-Type":
                MediaType.mediaTypeVendorThingIDUpdateRequest.rawValue
            ],
          requestBody:
            [
              "_vendorThingID": vendorThingID,
              "_password": password
            ],
          failureBeforeExecutionHandler: { completionHandler($0) }) {
            response, error -> Void in
            DispatchQueue.main.async { completionHandler(error) }
        }
    }

}
