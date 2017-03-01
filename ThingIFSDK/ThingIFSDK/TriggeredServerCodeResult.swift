import Foundation

/** Class represents result of server code trigged by trigger */
public class TriggeredServerCodeResult {

    /** Whether the invocation succeeded */
    public let succeeded: Bool
    /** Date of the execution */
    public let executedAt: Date
    /** The endpoint used in the server code invocation */
    public let endpoint: String
    /** Error object of the invocation if any */
    public let error: ServerError?

    /** Returned value from server code (JsonObject, JsonArray, String, Number, Boolean or null) */
    public let returnedValue: Any?

    /** Returned value from server code casted to String. */
    public var returnedValueAsString: String? {
        get {
            if let str = self.returnedValue as? String {
                return str
            } else if let num = self.returnedValue as? NSNumber {
                return String(describing: num)
            }
            return nil
        }
    }

    /** Returned value from server code casted to Bool. */
    public var returnedValueAsBool: Bool? {
        get {
            return self.returnedValue as? Bool
        }
    }

    /** Returned value from server code casted to Int. */
    public var returnedValueAsInt: Int? {
        get {
            return self.returnedValue as? Int
        }
    }

    /** Returned value from server code casted to Double. */
    public var returnedValueAsDouble: Double? {
        get {
            return self.returnedValue as? Double
        }
    }

    /** Returned value from server code casted to [String : Any]. */
    public var returnedValueAsDictionary: Dictionary<String, Any>? {
        get {
            return self.returnedValue as? Dictionary<String, Any>
        }
    }

    /** Returned value from server code casted to [Any]. */
    public var returnedValueAsArray: [Any]? {
        get {
            return self.returnedValue as? [Any]
        }
    }

    /** Initialize `TriggeredServerCodeResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameter succeeded: Whether the invocation succeeded
     - Parameter executedAt: Date of the execution
     - Parameter endpoint: The endpoint used in the server code invocation
     - Parameter returnedValue: Returned value from server code
     - Parameter error: Error object of the invocation if any
     */
    public init(
      succeeded: Bool,
      executedAt: Date,
      endpoint: String,
      returnedValue: Any? = nil,
      error: ServerError? = nil)
    {
        self.succeeded = succeeded
        self.executedAt = executedAt
        self.returnedValue = returnedValue
        self.endpoint = endpoint
        self.error = error
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
