import Foundation

/** Class represents result of server code trigged by trigger */
public class TriggeredServerCodeResult: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.succeeded, forKey: "succeeded")
        aCoder.encodeObject(self.returnedValue, forKey: "returnedValue")
        aCoder.encodeInt64(self.executedAt, forKey: "executedAt")
        aCoder.encodeObject(self.errorMessage, forKey: "errorMessage")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.succeeded = aDecoder.decodeObjectForKey("succeeded") as! Bool
        self.returnedValue = aDecoder.decodeObjectForKey("returnedValue") as? String
        self.executedAt = aDecoder.decodeObjectForKey("executedAt") as! Int64
        self.errorMessage = aDecoder.decodeObjectForKey("errorMessage") as? String
        // TODO: add aditional decoder
    }
    
    /** Whether the invocation succeeded */
    public var succeeded: Bool
    /** Returned value from server code */
    public var returnedValue: String?
    /** Timestamp of the execution */
    public var executedAt: Int64
    /** Error message of the invocation if any */
    public var errorMessage: String?
    
    
    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter succeeded: Whether the invocation succeeded
     - Parameter returnedValue: Returned value from server code
     - Parameter executedAt: Timestamp of the execution
     - Parameter errorMessage: Error message of the invocation if any
     */
    public init(succeeded: Bool, returnedValue: String?, executedAt: Int64, errorMessage: String?) {
        self.succeeded = succeeded
        self.returnedValue = returnedValue
        self.executedAt = executedAt
        self.errorMessage = errorMessage
    }

    
    class func resultWithNSDict(resultDict: NSDictionary) -> TriggeredServerCodeResult?{
        let succeeded = resultDict["succeeded"] as? Bool
        let returnedValue = resultDict["returnedValue"] as? String
        let executedAt = resultDict["executedAt"] as? Int64
        let errorMessage = resultDict["errorMessage"] as? String
        
        var result: TriggeredServerCodeResult?
        if succeeded != nil {
            result = TriggeredServerCodeResult(succeeded:succeeded!, returnedValue:returnedValue, executedAt:executedAt!, errorMessage:errorMessage)
        }
        return result
    }

}