//
//  IoTRequestOperation.swift
//  IoTCloudSDK
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
    let requestBodyData: NSData?
    let responseBodySerializer : (responseBodyData:NSData?) -> T?
    let completionHandler: (response: T?, error: IoTCloudError?) -> Void
    
}
typealias DefaultRequest = IotRequest<NSDictionary>

func buildDefaultRequest(method : HTTPMethod,urlString: String,requestHeaderDict: Dictionary<String, String>,requestBodyData: NSData?,completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void) -> DefaultRequest {
    kiiVerboseLog("Request URL: \(urlString)")
    kiiVerboseLog("Request Method: \(method)")
    kiiVerboseLog("Request Header: \(requestHeaderDict)")

    let defaultRequest = DefaultRequest(method: method, urlString: urlString, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, responseBodySerializer: { (responseBodyData) -> NSDictionary? in

        if responseBodyData == nil {
            return nil
        }
        var responseBody : NSDictionary?
        do{
            responseBody = try NSJSONSerialization.JSONObjectWithData(responseBodyData!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        }catch(_){
            kiiDebugLog("unable to parse JSON")
        }
        return responseBody
        }, completionHandler: completionHandler)
    
    return defaultRequest;
}

//use for dependency injection
var iotSession = NSURLSession.self

class IoTRequestOperation<T>: GroupOperation {
    init(request : IotRequest<T>){
        
        super.init(operations: [])
        
        //add operation that handle network unreachable, it will directly execute callback if network is unreachable.
        let url = NSURL(string: request.urlString)
        let notConnectedCondition = NegatedCondition<ReachabilityCondition>(condition: ReachabilityCondition(host: url!))
        let errorNotConnectedOperation = BlockOperation { () -> Void in
            let iotCloudError = IoTCloudError.CONNECTION
            request.completionHandler(response: nil, error: iotCloudError)
        }
        errorNotConnectedOperation.addCondition(notConnectedCondition)
        addOperation(errorNotConnectedOperation)
        
        switch(request.method) {
        case .POST :
            addPostRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, requestBodyData: request.requestBodyData!, completionHandler: request.completionHandler,responseBodySerializer:request.responseBodySerializer)
            
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
    
    func addPostRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: NSData, completionHandler: (response: T?, error: IoTCloudError?) -> Void,responseBodySerializer : (responseBodyData:NSData?) -> T?) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        // Set header to request
        setHeader(requestHeaderDict, request: request)
        
        request.HTTPBody = requestBodyData
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }
    
    func addPatchRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: NSData, completionHandler: (response: T?, error: IoTCloudError?) -> Void,responseBodySerializer : (responseBodyData:NSData?) -> T?) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PATCH"

        // Set header to request
        setHeader(requestHeaderDict, request: request)

        request.HTTPBody = requestBodyData
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }

    func addPutRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: NSData?, completionHandler: (response: T?, error: IoTCloudError?) -> Void,responseBodySerializer : (responseBodyData:NSData?) -> T?) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"

        // Set header to request
        setHeader(requestHeaderDict, request: request)

        if requestBodyData != nil {
            request.HTTPBody = requestBodyData
        }
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }

    func addGetRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, completionHandler: (response: T?, error: IoTCloudError?) -> Void,responseBodySerializer : (responseBodyData:NSData?) -> T?) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        // Set header to request
        setHeader(requestHeaderDict, request: request)
        
        addExecRequestTask(request,responseBodySerializer: responseBodySerializer) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }
    
    func addDeleteRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, completionHandler: (response: T?, error: IoTCloudError?) -> Void,responseBodySerializer : (responseBodyData:NSData?) -> T?) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        
        // Set header to request
        setHeader(requestHeaderDict, request: request)
        
        let session = iotSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (responseDataOptional: NSData?, responseOptional: NSURLResponse?, errorOptional: NSError?) -> Void in
            if responseOptional != nil {
                let httpResponse = responseOptional as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : NSDictionary?
                var errorCode = ""
                var errorMessage = ""
                kiiDebugLog("Response Status Code : \(statusCode)")
                if statusCode < 200 || statusCode >= 300 {
                    if responseDataOptional != nil {
                        do{
                            responseBody = try NSJSONSerialization.JSONObjectWithData(responseDataOptional!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        }catch(_){
                            kiiDebugLog("unable to parse JSON")
                        }
                    }
                    
                    if responseBody != nil{
                        errorCode = responseBody!["errorCode"] as! String
                        errorMessage = responseBody!["message"] as! String
                    }
                    let errorResponse = ErrorResponse(httpStatusCode: statusCode, errorCode: errorCode, errorMessage: errorMessage)
                    let iotCloudError = IoTCloudError.ERROR_RESPONSE(required: errorResponse)
                    completionHandler(response: nil, error: iotCloudError)
                }else {
                    completionHandler(response: nil, error: nil)
                }
            }
        })
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: request.URL!)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        addOperation(taskOperation)
    }
    
    func addExecRequestTask(request: NSURLRequest,responseBodySerializer : (responseBodyData:NSData?) -> T?, completionHandler: (response: T?, error: IoTCloudError?) -> Void) -> Void {
        
        let session = iotSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (responseDataOptional: NSData?, responseOptional: NSURLResponse?, errorOptional: NSError?) -> Void in
            kiiVerboseLog(responseDataOptional)
            if responseOptional != nil {
                let httpResponse = responseOptional as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : NSDictionary?
                var errorCode = ""
                var errorMessage = ""
                kiiDebugLog("Response Status Code : \(statusCode)")

                if statusCode < 200 || statusCode >= 300 {
                    if responseDataOptional != nil {
                        do{
                            responseBody = try NSJSONSerialization.JSONObjectWithData(responseDataOptional!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
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
                    let iotCloudError = IoTCloudError.ERROR_RESPONSE(required: errorResponse)
                    completionHandler(response: nil, error: iotCloudError)
                }else {
                    guard let serialized : T? = responseBodySerializer(responseBodyData: responseDataOptional) else{
                        completionHandler(response: nil,error: nil)
                        return
                    }
                    kiiDebugLog("Response Body serialized: \(serialized)")
                    completionHandler(response: serialized, error: nil)
                }
            }
        })
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: request.URL!)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        addOperation(taskOperation)
    }
    
    private func setHeader(headerDict: Dictionary<String, String>, request: NSMutableURLRequest) -> Void {
        for(key, value) in headerDict {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}