//
//  IoTRequestOperation.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

struct IotRequest<T> {
    let method : HTTPMethod
    let urlString: String
    let requestHeaderDict: Dictionary<String, String>
    let requestBodyData: Data?
    let responseBodySerializer : (_ responseBodyData:Data?) -> T?
    let completionHandler: (_ response: T?, _ error: ThingIFError?) -> Void
}
typealias DefaultRequest = IotRequest<NSDictionary>

func buildDefaultRequest(_ method : HTTPMethod,urlString: String,requestHeaderDict: Dictionary<String, String>,requestBodyData: Data?,completionHandler: @escaping (_ response: NSDictionary?, _ error: ThingIFError?) -> Void) -> DefaultRequest {
    kiiVerboseLog("Request URL: \(urlString)")
    kiiVerboseLog("Request Method: \(method)")
    kiiVerboseLog("Request Header: \(requestHeaderDict)")

    // Add X-Kii-SDK header.
    var modifiedHeaderDict = requestHeaderDict
    modifiedHeaderDict["X-Kii-SDK"] = SDKVersion.sharedInstance.kiiSDKHeader
    return buildNewRequest(method, urlString: urlString, requestHeaderDict: modifiedHeaderDict, requestBodyData: requestBodyData, completionHandler: completionHandler)
}

func buildNewRequest(_ method : HTTPMethod,urlString: String,requestHeaderDict: Dictionary<String, String>,requestBodyData: Data?,completionHandler: @escaping (_ response: NSDictionary?, _ error: ThingIFError?) -> Void) -> DefaultRequest {
    let defaultRequest = DefaultRequest(method: method, urlString: urlString, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, responseBodySerializer: { (responseBodyData) -> NSDictionary? in

        if responseBodyData == nil {
            return nil
        }
        var responseBody : NSDictionary?
        do{
            responseBody = try JSONSerialization.jsonObject(with: responseBodyData!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        }catch(_){
            kiiDebugLog("unable to parse JSON")
        }
        return responseBody
        }, completionHandler: completionHandler)
    
    return defaultRequest;
}

//use for dependency injection
var iotSession = URLSession.self

class IoTRequestOperation<T>: GroupOperation {
    init(request : IotRequest<T>){
        
        super.init(operations: [])
        
        //add operation that handle network unreachable, it will directly execute callback if network is unreachable.
        let url = URL(string: request.urlString)
        let notConnectedCondition = NegatedCondition<ReachabilityCondition>(condition: ReachabilityCondition(host: url!))
        let errorNotConnectedOperation = BlockOperation { () -> Void in
            let iotCloudError = ThingIFError.connection
            request.completionHandler(nil, iotCloudError)
        }
        errorNotConnectedOperation.addCondition(notConnectedCondition)
        addOperation(errorNotConnectedOperation)
        
        switch(request.method) {
        case .POST :
            addPostRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, requestBodyData: request.requestBodyData, completionHandler: request.completionHandler,responseBodySerializer:request.responseBodySerializer)
            
        case .GET:
            addGetRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, completionHandler: request.completionHandler,responseBodySerializer:request.responseBodySerializer)

        case .DELETE:
            addDeleteRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, completionHandler: request.completionHandler,responseBodySerializer:request.responseBodySerializer)

        case .PATCH:
            addPatchRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, requestBodyData: request.requestBodyData!, completionHandler: request.completionHandler,responseBodySerializer:request.responseBodySerializer)

        case .PUT:
            addPutRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, requestBodyData: request.requestBodyData, completionHandler: request.completionHandler, responseBodySerializer: request.responseBodySerializer)

        default :
            break
        }
    }
    
    func addPostRequestTask(_ urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: Data?, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void,responseBodySerializer : @escaping (_ responseBodyData:Data?) -> T?) -> Void
    {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Set header to request
        setHeader(requestHeaderDict, request: &request)

        if requestBodyData != nil {
            request.httpBody = requestBodyData
        }
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response, error)
        }
    }
    
    func addPatchRequestTask(_ urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: Data, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void,responseBodySerializer : @escaping (_ responseBodyData:Data?) -> T?) -> Void
    {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PATCH"

        // Set header to request
        setHeader(requestHeaderDict, request: &request)

        request.httpBody = requestBodyData
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response, error)
        }
    }

    func addPutRequestTask(_ urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: Data?, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void,responseBodySerializer : @escaping (_ responseBodyData:Data?) -> T?) -> Void
    {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"

        // Set header to request
        setHeader(requestHeaderDict, request: &request)

        if requestBodyData != nil {
            request.httpBody = requestBodyData
        }
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response, error)
        }
    }

    func addGetRequestTask(_ urlString: String, requestHeaderDict: Dictionary<String, String>, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void,responseBodySerializer : @escaping (_ responseBodyData:Data?) -> T?) -> Void
    {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        // Set header to request
        setHeader(requestHeaderDict, request: &request)
        
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response, error)
        }
    }
    
    func addDeleteRequestTask(_ urlString: String, requestHeaderDict: Dictionary<String, String>, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void,responseBodySerializer : (_ responseBodyData:Data?) -> T?) -> Void
    {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        // Set header to request
        setHeader(requestHeaderDict, request: &request)
        
        let session = iotSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (responseDataOptional, responseOptional, errorOptional) -> Void in
            if responseOptional != nil {
                let httpResponse = responseOptional as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : NSDictionary?
                var errorCode = ""
                var errorMessage = ""
                kiiDebugLog("Response Status Code : \(statusCode)")
                if statusCode < 200 || statusCode >= 300 {
                    if responseDataOptional != nil {
                        do{
                            responseBody = try JSONSerialization.jsonObject(with: responseDataOptional!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        }catch(_){
                            kiiDebugLog("unable to parse JSON")
                        }
                    }
                    
                    if responseBody != nil{
                        errorCode = responseBody!["errorCode"] as! String
                        errorMessage = responseBody!["message"] as! String
                    }
                    let errorResponse = ErrorResponse(httpStatusCode: statusCode, errorCode: errorCode, errorMessage: errorMessage)
                    let iotCloudError = ThingIFError.error_RESPONSE(required: errorResponse)
                    completionHandler(nil, iotCloudError)
                }else {
                    completionHandler(nil, nil)
                }
            }else{
                completionHandler(nil, ThingIFError.error_REQUEST(required: errorOptional! as NSError))
            }
        })
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: request.url!)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        addOperation(taskOperation)
    }
    
    func addExecRequestTask(_ request: URLRequest,responseBodySerializer : @escaping (_ responseBodyData:Data?) -> T?, completionHandler: @escaping (_ response: T?, _ error: ThingIFError?) -> Void) -> Void {
        
        let session = iotSession.shared
        let task = session.dataTask(with: request, completionHandler: { (responseDataOptional: Data?, responseOptional: URLResponse?, errorOptional: Error?) -> Void in
            kiiVerboseLog(responseDataOptional)
            if responseOptional != nil {
                let httpResponse = responseOptional as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : NSDictionary?
                var errorCode = ""
                var errorMessage = ""
                kiiDebugLog("Response Status Code : \(statusCode)")

                if statusCode < 200 || statusCode >= 300 {
                    if responseDataOptional != nil {
                        do{
                            responseBody = try JSONSerialization.jsonObject(with: responseDataOptional!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        }catch(_){
                            kiiDebugLog("unable to parse JSON")
                        }
                    }
                    kiiDebugLog("Response Error : \(responseBody)")
                    if responseBody != nil
                        && responseBody!["errorCode"] != nil
                        && responseBody!["message"] != nil {
                        errorCode = responseBody!["errorCode"] as! String
                        errorMessage = responseBody!["message"] as! String
                    }
                    let errorResponse = ErrorResponse(httpStatusCode: statusCode, errorCode: errorCode, errorMessage: errorMessage)
                    let iotCloudError = ThingIFError.error_RESPONSE(required: errorResponse)
                    completionHandler(nil, iotCloudError)
                }else {
                    guard let serialized : T = responseBodySerializer(responseDataOptional) else {
                        completionHandler(nil,nil)
                        return
                    }
                    kiiDebugLog("Response Body serialized: \(serialized)")
                    completionHandler(serialized, nil)
                }
            }else{
                completionHandler(nil, ThingIFError.error_REQUEST(required: errorOptional as! NSError))
            }
        })
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: request.url!)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        addOperation(taskOperation)
    }
    
    private func setHeader(_ headerDict: Dictionary<String, String>, request: inout URLRequest) -> Void {
        for(key, value) in headerDict {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}
