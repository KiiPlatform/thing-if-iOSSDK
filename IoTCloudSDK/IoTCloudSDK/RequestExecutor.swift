//
//  RequestExecutor.swift
//  IoTCloudSDK
//
//

import Foundation

public class RequestExecutor{

public func postRequest(urlString: String, requestHeaderDict: Dictionary<String, String>, requestBodyData: NSData, completionHandler: (response: NSDictionary?, error: IoTCloudError?) -> Void) -> Void
{
    let url = NSURL(string: urlString)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "POST"

    // Set header to request
    setHeader(requestHeaderDict, request: request)

    request.HTTPBody = requestBodyData
    let session = NSURLSession.sharedSession()
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
    task.resume()
}

func setHeader(headerDict: Dictionary<String, String>, request: NSMutableURLRequest) -> Void {
    for(key, value) in headerDict {
        request.addValue(value, forHTTPHeaderField: key)
    }
}
}
