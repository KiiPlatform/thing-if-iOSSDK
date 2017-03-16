//
//  ThingIFAPI+GetState.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {
    func _getTargetStates(
        _ completionHandler: @escaping ([String : [String : Any]]?,  ThingIFError?)-> Void) {

        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
            .GET,
            url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/states",
            requestHeader:
            self.defaultHeader + ["Content-Type" : "application/json" ],
            requestBody: nil,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler(response as? [String : [String : Any]], error)
                }
            }
    }

    func _getTargetState(
        _ alias: String,
        completionHandler:@escaping ([String : Any]?, ThingIFError?)-> Void) {

        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
            .GET,
            url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/states/aliases/\(alias)",
            requestHeader:
            self.defaultHeader + ["Content-Type" : "application/json" ],
            requestBody: nil,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler(response, error)
                }
        }
    }
}
