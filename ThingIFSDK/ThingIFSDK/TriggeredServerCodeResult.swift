import Foundation

/** Class represents result of server code trigged by trigger */
open class TriggeredServerCodeResult: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.succeeded, forKey: "succeeded")
        aCoder.encode(self.returnedValue, forKey: "returnedValue")
        aCoder.encode(self.executedAt.timeIntervalSince1970, forKey: "executedAt")
        aCoder.encode(self.endpoint, forKey: "endpoint")
        aCoder.encode(self.error, forKey: "error")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.succeeded = aDecoder.decodeBool(forKey: "succeeded")
        self.returnedValue = aDecoder.decodeObject(forKey: "returnedValue")
        self.executedAt = Date(timeIntervalSince1970: aDecoder.decodeDouble(forKey: "executedAt"))
        self.endpoint = aDecoder.decodeObject(forKey: "endpoint") as! String
        self.error = aDecoder.decodeObject(forKey: "error") as? ServerError
        // TODO: add aditional decoder
    }
    
    /** Whether the invocation succeeded */
    open let succeeded: Bool
    /** Returned value from server code (JsonObject, JsonArray, String, Number, Boolean or null) */
    open let returnedValue: Any?
    /** Date of the execution */
    open let executedAt: Date
    /** The endpoint used in the server code invocation */
    open let endpoint: String
    /** Error object of the invocation if any */
    open let error: ServerError?
    
    
    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter succeeded: Whether the invocation succeeded
     - Parameter returnedValue: Returned value from server code
     - Parameter executedAt: Date of the execution
     - Parameter endpoint: The endpoint used in the server code invocation
     - Parameter error: Error object of the invocation if any
     */
    public init(succeeded: Bool, returnedValue: Any?, executedAt: Date, endpoint: String, error: ServerError?) {
        self.succeeded = succeeded
        self.returnedValue = returnedValue
        self.executedAt = executedAt
        self.endpoint = endpoint
        self.error = error
    }
    
    open func getReturnedValue() -> Any? {
        return self.returnedValue
    }
    open func getReturnedValueAsString() -> String? {
        if let str = self.returnedValue as? String {
            return str
        }
        if let num = self.returnedValue as? NSNumber {
            return String(describing: num)
        }
        return nil
    }
    open func getReturnedValueAsBool() -> Bool? {
        return self.returnedValue as? Bool
    }
    open func getReturnedValueAsNSNumber() -> NSNumber? {
        return self.returnedValue as? NSNumber
    }
    open func getReturnedValueAsDictionary() -> Dictionary<String, Any>? {
        return self.returnedValue as? Dictionary<String, Any>
    }
    open func getReturnedValueAsArray() -> [Any]? {
        return self.returnedValue as? [Any]
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let aResult = object as? TriggeredServerCodeResult else{
            return false
        }
        if self.returnedValue == nil || aResult.returnedValue == nil {
            if self.returnedValue != nil || aResult.returnedValue != nil {
                return false
            }
        } else {
            if self.returnedValue! is Dictionary<String, Any> {
                if !NSDictionary(dictionary: self.returnedValue as! [AnyHashable: Any]).isEqual(to: aResult.returnedValue as! [AnyHashable: Any]) {
                    return false
                }
            } else if self.returnedValue! is [Any] {
                if !isEqualArray(self.returnedValue as! [Any], arr2: aResult.returnedValue as! [Any]) {
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
    private func isEqualArray(_ arr1:[Any], arr2:[Any]) -> Bool {
        if arr1.count != arr2.count {
            return false
        }
        for i in 0 ..< arr1.count {
            let e1 = arr1[i]
            let e2 = arr2[i]
            if e1 is Dictionary<String, Any> {
                if !NSDictionary(dictionary: e1 as! [AnyHashable: Any]).isEqual(to: e2 as! [AnyHashable: Any]) {
                    return false
                }
            } else if e1 is [Any] {
                if !isEqualArray(e1 as! [Any], arr2: e2 as! [Any]) {
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
    
    class func resultWithNSDict(_ resultDict: NSDictionary) -> TriggeredServerCodeResult?{
        guard let succeeded = resultDict["succeeded"] as? Bool else{
            return nil
        }
        guard let executedAtStamp = resultDict["executedAt"] as? NSNumber else{
            return nil
        }
        let returnedValue = resultDict["returnedValue"]
        
        let error = resultDict["error"] as? Dictionary<String, Any>
        var serverError: ServerError? = nil
        if error != nil {
            serverError = ServerError.errorWithNSDict(error! as NSDictionary)
        }
        let executedAt = Date(timeIntervalSince1970: (executedAtStamp.doubleValue)/1000.0)
        let endpoint = resultDict["endpoint"] as! String
        return TriggeredServerCodeResult(succeeded:succeeded, returnedValue:returnedValue, executedAt:executedAt, endpoint:endpoint, error:serverError)
    }
}

open class ServerError: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.errorMessage, forKey: "errorMessage")
        aCoder.encode(self.errorCode, forKey: "errorCode")
        aCoder.encode(self.detailMessage, forKey: "detailMessage")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.errorMessage = aDecoder.decodeObject(forKey: "errorMessage") as? String
        self.errorCode = aDecoder.decodeObject(forKey: "errorCode") as? String
        self.detailMessage = aDecoder.decodeObject(forKey: "detailMessage") as? String
    }
    
    open let errorMessage: String?
    open let errorCode: String?
    open let detailMessage: String?
    
    init(errorMessage: String?, errorCode: String?, detailMessage: String?) {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.detailMessage = detailMessage
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let aResult = object as? ServerError else{
            return false
        }
        return self.errorMessage == aResult.errorMessage && self.errorCode == aResult.errorCode && self.detailMessage == aResult.detailMessage
    }
    
    class func errorWithNSDict(_ errorDict: NSDictionary) -> ServerError?{
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
