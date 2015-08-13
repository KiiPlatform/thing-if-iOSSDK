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
}

struct IotRequest {
    let method : HTTPMethod
    let urlString: String
    let requestHeaderDict: Dictionary<String, String>
    let requestBodyData: NSData?
    let completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void
    
}
//use for dependency injection
var iotSession = NSURLSession.self

class IoTRequestOperation: GroupOperation {
    init(request : IotRequest){

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
            addPostRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, requestBodyData: request.requestBodyData!, completionHandler: request.completionHandler)

        case .GET:
            addGetRequestTask(request.urlString, requestHeaderDict: request.requestHeaderDict, completionHandler: request.completionHandler)
        default :
            break
        }
    }

    func addPostRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: NSData, completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        // Set header to request
        setHeader(requestHeaderDict, request: request)

        request.HTTPBody = requestBodyData
        addExecRequestTask(request) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }

    func addGetRequestTask(urlString: String, requestHeaderDict: Dictionary<String, String>, completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void) -> Void
    {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"

        // Set header to request
        setHeader(requestHeaderDict, request: request)

        addExecRequestTask(request) { (response, error) -> Void in
            completionHandler(response: response, error: error)
        }
    }

    func addExecRequestTask(request: NSURLRequest, completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void) -> Void {

        let session = iotSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (responseDataOptional: NSData?, responseOptional: NSURLResponse?, errorOptional: NSError?) -> Void in
            if responseOptional != nil {
                let httpResponse = responseOptional as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : NSDictionary?
                var errorCode = ""
                var errorMessage = ""
                if responseDataOptional != nil {
                    do{
                        responseBody = try NSJSONSerialization.JSONObjectWithData(responseDataOptional!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    }catch(_){
                        // do nothing
                        //TODO: change to debug log
                        print("")
                    }
                }
                if statusCode < 200 || statusCode >= 300 {

                    if responseBody != nil{
                        errorCode = responseBody!["errorCode"] as! String
                        errorMessage = responseBody!["message"] as! String
                    }
                    let errorResponse = ErrorResponse(httpStatusCode: statusCode, errorCode: errorCode, errorMessage: errorMessage)
                    let iotCloudError = IoTCloudError.ERROR_RESPONSE(required: errorResponse)
                    completionHandler(response: nil, error: iotCloudError)
                }else {
                    completionHandler(response: responseBody, error: nil)
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