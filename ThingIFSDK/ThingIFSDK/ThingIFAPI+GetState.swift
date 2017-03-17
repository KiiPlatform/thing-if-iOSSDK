//
//  ThingIFAPI+GetState.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    // MARK: - Getting thing state methods

    /** Get the state of specified target.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     - Parameter completionHandler: A closure to be executed once get
       state has finished. The closure takes 2 arguments: 1st one is
       Dictionary that represent Target State and 2nd one is an
       instance of ThingIFError when failed.
    */
    open func getTargetState(
      _ completionHandler:@escaping ([String : [String : Any]]?,
                                     ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
            .GET,
            url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/states",
            requestHeader: self.defaultHeader,
            requestBody: nil,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler(response as? [String : [String : Any]], error)
                }
            }
    }

    /** Get the state of specified target by trait.

     **Note**: Please onboard first, or provide a target instance by
     calling copyWithTarget. Otherwise,
     KiiCloudError.TARGET_NOT_AVAILABLE will be return in
     completionHandler callback

     You can not use this method if You chose non trait verson.

     - Parameter alias: alias of trait.
     - Parameter completionHandler: A closure to be executed once get
       state has finished. The closure takes 2 arguments: 1st one is
       Dictionary that represent Target State and 2nd one is an
       instance of ThingIFError when failed.
     */
    open func getTargetState(
      _ alias: String,
      completionHandler:@escaping ([String : Any]?,
                                   ThingIFError?)-> Void) -> Void
    {
        guard let target = self.target else {
            completionHandler(nil, ThingIFError.targetNotAvailable)
            return
        }

        self.operationQueue.addHttpRequestOperation(
            .GET,
            url: "\(baseURL)/thing-if/apps/\(appID)/targets/\(target.typedID.toString())/states/aliases/\(alias)",
            requestHeader: self.defaultHeader,
            requestBody: nil,
            failureBeforeExecutionHandler: { completionHandler(nil, $0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler(response, error)
                }
        }
    }
}
