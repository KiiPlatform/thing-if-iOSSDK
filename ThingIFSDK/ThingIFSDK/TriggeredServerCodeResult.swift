import Foundation

/** Class represents result of server code trigged by trigger */
public class TriggeredServerCodeResult: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.succeeded, forKey: "succeeded")
        aCoder.encodeObject(self.returnedValue, forKey: "returnedValue")
        aCoder.encodeDouble(self.executedAt.timeIntervalSince1970, forKey: "executedAt")
        aCoder.encodeObject(self.endpoint, forKey: "endpoint")
        aCoder.encodeObject(self.error, forKey: "error")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.succeeded = aDecoder.decodeBoolForKey("succeeded")
        self.returnedValue = aDecoder.decodeObjectForKey("returnedValue") as AnyObject?
        self.executedAt = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("executedAt"))
        self.endpoint = aDecoder.decodeObjectForKey("endpoint") as! String
        self.error = aDecoder.decodeObjectForKey("error") as? ServerError
        // TODO: add aditional decoder
    }
    
    /** Whether the invocation succeeded */
    public let succeeded: Bool
    /** Returned value from server code (JsonObject, JsonArray, String, Number, Boolean or null) */
    public let returnedValue: AnyObject?
    /** Date of the execution */
    public let executedAt: NSDate
    /** The endpoint used in the server code invocation */
    public let endpoint: String
    /** Error object of the invocation if any */
    public let error: ServerError?
    
    
    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter succeeded: Whether the invocation succeeded
     - Parameter returnedValue: Returned value from server code
     - Parameter executedAt: Date of the execution
     - Parameter endpoint: The endpoint used in the server code invocation
     - Parameter error: Error object of the invocation if any
     */
    public init(succeeded: Bool, returnedValue: AnyObject?, executedAt: NSDate, endpoint: String, error: ServerError?) {
        self.succeeded = succeeded
        self.returnedValue = returnedValue
        self.executedAt = executedAt
        self.endpoint = endpoint
        self.error = error
    }
    
    public func getReturnedValue() -> AnyObject? {
        return self.returnedValue
    }
    public func getReturnedValueAsString() -> String? {
        if let str = self.returnedValue as? String {
            return str
        }
        if let num = self.returnedValue as? NSNumber {
            return String(num)
        }
        return nil
    }
    public func getReturnedValueAsBool() -> Bool? {
        return self.returnedValue as? Bool
    }
    public func getReturnedValueAsNSNumber() -> NSNumber? {
        return self.returnedValue as? NSNumber
    }
    public func getReturnedValueAsDictionary() -> Dictionary<String, AnyObject>? {
        return self.returnedValue as? Dictionary<String, AnyObject>
    }
    public func getReturnedValueAsArray() -> [AnyObject]? {
        return self.returnedValue as? [AnyObject]
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aResult = object as? TriggeredServerCodeResult else{
            return false
        }
        if self.returnedValue == nil || aResult.returnedValue == nil {
            if self.returnedValue != nil || aResult.returnedValue != nil {
                return false
            }
        } else {
            if self.returnedValue! is Dictionary<String, AnyObject> {
                if !NSDictionary(dictionary: self.returnedValue as! [NSObject : AnyObject]).isEqualToDictionary(aResult.returnedValue as! [NSObject : AnyObject]) {
                    return false
                }
            } else if self.returnedValue! is [AnyObject] {
                if !isEqualArray(self.returnedValue as! [AnyObject], arr2: aResult.returnedValue as! [AnyObject]) {
                    return false
                }
            } else if self.returnedValue! is String {
                if self.returnedValue as! String != aResult.returnedValue as! String {
                    return false
                }
            } else if self.returnedValue! is NSNumber {
                if self.returnedValue as! NSNumber != aResult.returnedValue as! NSNumber {
                    return false
                }
            } else if self.returnedValue! is Bool {
                if self.returnedValue as! Bool != aResult.returnedValue as! Bool {
                    return false
                }
            }
        }
        if self.error == nil || aResult.error == nil {
            if self.error != nil || aResult.error != nil {
                return false
            }
        } else if (!self.error!.isEqual(aResult.error!)) {
            return false
        }
        return self.succeeded == aResult.succeeded && self.executedAt == aResult.executedAt && self.endpoint == aResult.endpoint
    }
    private func isEqualArray(arr1:[AnyObject], arr2:[AnyObject]) -> Bool {
        if arr1.count != arr2.count {
            return false
        }
        for i in 0 ..< arr1.count {
            let e1 = arr1[i]
            let e2 = arr2[i]
            if e1 is Dictionary<String, AnyObject> {
                if !NSDictionary(dictionary: e1 as! [NSObject : AnyObject]).isEqualToDictionary(e2 as! [NSObject : AnyObject]) {
                    return false
                }
            } else if e1 is [AnyObject] {
                if !isEqualArray(e1 as! [AnyObject], arr2: e2 as! [AnyObject]) {
                    return false
                }
            } else if e1 is String {
                if e1 as! String != e2 as! String {
                    return false
                }
            } else if e1 is NSNumber {
                if e1 as! NSNumber != e2 as! NSNumber {
                    return false
                }
            } else if e1 is Bool {
                if e1 as! Bool != e2 as! Bool {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
    
    class func resultWithNSDict(resultDict: NSDictionary) -> TriggeredServerCodeResult?{
        guard let succeeded = resultDict["succeeded"] as? Bool else{
            return nil
        }
        guard let executedAtStamp = resultDict["executedAt"] as? NSNumber else{
            return nil
        }
        let returnedValue = resultDict["returnedValue"] as AnyObject?
        
        let error = resultDict["error"] as? Dictionary<String, AnyObject>
        var serverError: ServerError? = nil
        if error != nil {
            serverError = ServerError.errorWithNSDict(error!)
        }
        let executedAt = NSDate(timeIntervalSince1970: (executedAtStamp.doubleValue)/1000.0)
        let endpoint = resultDict["endpoint"] as! String
        return TriggeredServerCodeResult(succeeded:succeeded, returnedValue:returnedValue, executedAt:executedAt, endpoint:endpoint, error:serverError)
    }
}

public class ServerError: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.errorMessage, forKey: "errorMessage")
        aCoder.encodeObject(self.errorCode, forKey: "errorCode")
        aCoder.encodeObject(self.detailMessage, forKey: "detailMessage")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.errorMessage = aDecoder.decodeObjectForKey("errorMessage") as? String
        self.errorCode = aDecoder.decodeObjectForKey("errorCode") as? String
        self.detailMessage = aDecoder.decodeObjectForKey("detailMessage") as? String
    }
    
    public let errorMessage: String?
    public let errorCode: String?
    public let detailMessage: String?
    
    init(errorMessage: String?, errorCode: String?, detailMessage: String?) {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.detailMessage = detailMessage
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aResult = object as? ServerError else{
            return false
        }
        return self.errorMessage == aResult.errorMessage && self.errorCode == aResult.errorCode && self.detailMessage == aResult.detailMessage
    }
    
    class func errorWithNSDict(errorDict: NSDictionary) -> ServerError?{
        let errorMessage = errorDict["errorMessage"] as? String
        let details = errorDict["details"] as? NSDictionary
        var errorCode: String?
        var detailMessage: String?
        if details != nil {
            errorCode = details!["errorCode"] as? String
            detailMessage = details!["message"] as? String
        }
        return ServerError(errorMessage: errorMessage, errorCode: errorCode, detailMessage: detailMessage)
    }

}
