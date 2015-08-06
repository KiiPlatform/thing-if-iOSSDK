//
//  RequestExecutor.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/6/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

public func postRequest(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyDict: Dictionary<String, String>, completionHandler: (response: Dictionary<String, Any>?, error: IoTCloudError?) -> Void) throws -> Void
{
    let url = NSURL(string: urlString)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"
    setHeader(requestHeaderDict, request: request)
    do{
        let jsonBody = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
        request.HTTPBody = jsonBody
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (responseDataOptional: NSData?, responseOptional: NSURLResponse?, errorOptional: NSError?) -> Void in
            if responseOptional != nil {
                let httpResponse = responseOptional as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                var responseBody : Dictionary<String, Any>?
                var errorCode = ""
                var errorMessage = ""
                if responseDataOptional != nil {
                    do{
                    responseBody =  try NSJSONSerialization.JSONObjectWithData(responseDataOptional!, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, Any>
                        errorCode = responseBody!["errorCode"] as! String
                        errorMessage = responseBody!["errorMessage"] as! String
                    }catch(_){
                        // do nothing
                    }
                }
                if statusCode < 200 || statusCode >= 300 {
                    let errorResponse = ErrorResponse(httpStatusCode: statusCode, errorCode: errorCode, errorMessage: errorMessage)
                    let iotCloudError = IoTCloudError.ERROR_RESPONSE(required: errorResponse)
                    completionHandler(response: nil, error: iotCloudError)
                }else {
                    completionHandler(response: responseBody, error: nil)
                }
            }
        })
        task.resume()
        
    }catch(let e){
        throw e
    }
    
}

func setHeader(headerDict: Dictionary<String, String>, request: NSMutableURLRequest) -> Void {
    for(key, value) in headerDict {
        request.addValue(value, forHTTPHeaderField: key)
    }
}
