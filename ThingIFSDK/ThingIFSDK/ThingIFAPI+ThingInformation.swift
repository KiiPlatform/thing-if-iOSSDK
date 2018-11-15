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
        if vendorThingID.isEmpty {
            completionHandler(ThingIFError.invalidArgument(
                                message: "vendorThingID is empty."))
            return
        }
        if password.isEmpty {
            completionHandler(ThingIFError.invalidArgument(
                                message: "password is empty."))
            return
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

    /** Get firmware version.

     This method gets firmware version for `target` thing.

     - Parameter completionHandler: A closure to be executed once on
       getting has finished The closure takes 2 arguments. First one
       is firmware version. Second one is ThingIFError.
     */
    open func getFirmwareVersion(
      _ completionHandler: @escaping (String?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/things/\(target.typedID.id)/firmware-version",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in
            let result = convertResponse(response, error) {
                json, error -> (String?, ThingIFError?) in

                if let error = error {
                    switch error {
                    case .errorResponse(let response) where
                           response.errorCode == "THING_WITHOUT_FIRMWARE_VERSION":
                        return (nil, nil)
                    default:
                        return (nil, error)
                    }
                }
                return (json?["firmwareVersion"] as? String, nil)
            }
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }

    /** Update firmware version.

     This method updates firmware version for `target` thing.

     - Parameter firmwareVersion: firmwareVersion to be updated.
     - Parameter completionHandler: A closure to be executed once on
       updating has finished The closure takes 1 argument. The
       argument is ThingIFError.
     */
    open func update(
      firmwareVersion: String,
      completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }
        if firmwareVersion.isEmpty {
            completionHandler(
              ThingIFError.invalidArgument(message: "firmwareVersionis empty."))
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .put,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/things/\(target.typedID.id)/firmware-version",
          requestHeader:
            self.defaultHeader +
            [
              "Content-Type":
                MediaType.mediaTypeThingFirmwareVersionUpdateRequest.rawValue
            ],
          requestBody: ["firmwareVersion": firmwareVersion],
          failureBeforeExecutionHandler: { completionHandler($0) }) {
            response, error -> Void in
            DispatchQueue.main.async { completionHandler(error) }
        }
    }

    /** Get thing type.

     This method gets thing type for `target` thing.

     - Parameter completionHandler: A closure to be executed once on
       getting has finished The closure takes 2 arguments. First one
       is thing type. Second one is ThingIFError.
     */
    open func getThingType(
      _ completionHandler: @escaping (String?, ThingIFError?) -> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .get,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/things/\(target.typedID.id)/thing-type",
          requestHeader: self.defaultHeader,
          failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
            response, error -> Void in
            let result = convertResponse(response, error) {
                json, error -> (String?, ThingIFError?) in

                if let error = error {
                    switch error {
                    case .errorResponse(let response) where
                           response.errorCode == "THING_WITHOUT_THING_TYPE":
                        return (nil, nil)
                    default:
                        return (nil, error)
                    }
                }
                return (json?["thingType"] as? String, nil)
            }
            DispatchQueue.main.async { completionHandler(result.0, result.1) }
        }
    }

    /** Update thing type.

     This method updates thing type for `target` thing.

     - Parameter thingType: thing type to be updated.
     - Parameter completionHandler: A closure to be executed once on
       updating has finished The closure takes 1 argument. The
       argument is ThingIFError.
     */
    open func update(
      thingType: String,
      completionHandler: @escaping (ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }
        if thingType.isEmpty {
            completionHandler(
              ThingIFError.invalidArgument(message: "thingType is empty."))
            return;
        }

        self.operationQueue.addHttpRequestOperation(
          .put,
          url: "\(self.baseURL)/thing-if/apps/\(self.appID)/things/\(target.typedID.id)/thing-type",
          requestHeader:
            self.defaultHeader +
            [
              "Content-Type":
                MediaType.mediaTypeThingTypeUpdateRequest.rawValue
            ],
          requestBody: ["thingType": thingType],
          failureBeforeExecutionHandler: { completionHandler($0) }) {
            response, error -> Void in
            DispatchQueue.main.async { completionHandler(error) }
        }
    }

}
