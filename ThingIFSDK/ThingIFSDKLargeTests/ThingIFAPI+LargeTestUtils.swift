//
//  ThingIFAPI+LargeTestUtils.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

extension ThingIFAPI {

    internal func updateTargetState(
        _ alias: String,
        state: [String : Any],
        completionHandler: @escaping(ThingIFError?) -> Void) -> Void
    {
        updateTargetStates(
            [ alias: state ],
            completionHandler: completionHandler)
    }

    internal func updateTargetStates(
        _ body: [String : Any],
        completionHandler: @escaping(ThingIFError?) -> Void) -> Void
    {
        if self.target == nil {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
            .put,
            url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states",
            requestHeader: self.defaultHeader + [
                "Content-Type" : "application/vnd.kii.MultipleTraitState+json"
            ],
            requestBody: body,
            failureBeforeExecutionHandler: { completionHandler($0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler( error)
                }
        }
    }
}
