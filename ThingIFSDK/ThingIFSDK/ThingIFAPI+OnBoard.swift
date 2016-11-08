//
//  ThingIFAPI+OnBoard.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
extension ThingIFAPI {

    func _onboard(
        _ byVendorThingID: Bool,
        IDString: String,
        thingPassword:String,
        thingType:String? = nil,
        firmwareVersion:String? = nil,
        thingProperties:Dictionary<String, Any>? = nil,
        layoutPosition:LayoutPosition? = nil,
        dataGroupingInterval:DataGroupingInterval? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void {

            if self.target != nil {
                completionHandler(nil, ThingIFError.already_ONBOARDED)
                return
            }
            
            let requestURL = "\(baseURL)/thing-if/apps/\(appID)/onboardings"
            
            // genrate body
            var requestBodyDict: Dictionary<String, Any> =
              [
                "thingPassword": thingPassword,
                "owner": owner.typedID.toString()
              ]
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)"]
            
            if byVendorThingID {
                requestBodyDict["vendorThingID"] = IDString
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            } else {
                requestBodyDict["thingID"] = IDString
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            }

            requestBodyDict["thingType"] = thingType

            requestBodyDict["firmwareVersion"] = firmwareVersion

            requestBodyDict["thingProperties"] = thingProperties

            requestBodyDict["layoutPosition"] = layoutPosition?.rawValue

            requestBodyDict["dataGroupingInterval"] = dataGroupingInterval?.rawValue

            do{
                let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                // do request
                let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                    
                    var target:Target?
                    if let thingID = response?["thingID"] as? String{
                        let accessToken = response?["accessToken"] as? String
                        /* TODO:
                            Idealy server should send vendorThingID as response of onboarding,
                            and SDK should use the received vendorThingID.
                            However, current server implementation does not send vendorThingID.
                            So we used IDString if it is vendorThingID, otherwise we set it empty string.
                            This behavior should be fixed after server fixed.
                        */
                        let vendorThingID: String
                        if byVendorThingID {
                            vendorThingID = IDString
                        } else {
                            vendorThingID = ""
                        }
                        if layoutPosition == LayoutPosition.gateway {
                            target = Gateway(
                                    thingID: thingID,
                                    vendorThingID: vendorThingID,
                                    accessToken: accessToken)
                        } else if layoutPosition == LayoutPosition.endnode {
                            target = EndNode(
                                    thingID: thingID,
                                    vendorThingID: vendorThingID,
                                    accessToken: accessToken)
                        } else {
                            target = StandaloneThing(
                                    thingID: thingID,
                                    vendorThingID: vendorThingID,
                                    accessToken: accessToken)
                        }

                        self._target = target
                    }
                    self.saveToUserDefault()
                    DispatchQueue.main.async {
                        completionHandler(target, error)
                    }
                })
                let operation = IoTRequestOperation(request: request)
                operationQueue.addOperation(operation)
                
            }catch(_){
                kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
                completionHandler(nil, ThingIFError.json_PARSE_ERROR)
            }
    }

    func _onboardEndnodeWithGateway(
        _ pendingEndnode:PendingEndNode,
        endnodePassword:String,
        options:OnboardEndnodeWithGatewayOptions? = nil,
        completionHandler: @escaping (EndNode?, ThingIFError?)-> Void
        ) ->Void
    {
        if self.target == nil || !(self.target is Gateway) {
            completionHandler(nil, ThingIFError.target_NOT_AVAILABLE)
            return
        }
        if pendingEndnode.vendorThingID == nil || pendingEndnode.vendorThingID!.isEmpty {
            completionHandler(nil, ThingIFError.unsupported_ERROR)
            return
        }
        if endnodePassword.isEmpty {
            completionHandler(nil, ThingIFError.unsupported_ERROR)
            return
        }

        let requestURL = "\(self.baseURL)/thing-if/apps/\(self.appID)/onboardings"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)",
            "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
        ]

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "gatewayThingID": self.target!.typedID.id,
                "endNodeVendorThingID": pendingEndnode.vendorThingID!,
                "endNodePassword": endnodePassword,
                "owner": self.owner.typedID.toString()
            ]
        )

        requestBodyDict["endNodeThingType"] = pendingEndnode.thingType

        if !(pendingEndnode.thingProperties?.isEmpty ?? true) {
            requestBodyDict["endNodeThingProperties"] = pendingEndnode.thingProperties
        }

        requestBodyDict["dataGroupingInterval"] = options?.dataGroupingInterval?.rawValue

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(
                HTTPMethod.POST,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    let endNode: EndNode?
                    if error != nil {
                        endNode = nil
                    } else {
                        let thingID = response?["endNodeThingID"] as! String
                        let accessToken = response?["accessToken"] as! String
                        endNode = EndNode(thingID: thingID, vendorThingID: pendingEndnode.vendorThingID!, accessToken: accessToken)
                    }
                    DispatchQueue.main.async {
                        completionHandler(endNode, error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(nil, ThingIFError.json_PARSE_ERROR)
        }
    }
}
