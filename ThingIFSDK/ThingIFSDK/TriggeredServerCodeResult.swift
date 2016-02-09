import Foundation

/** Class represents result of server code trigged by trigger */
public class TriggeredServerCodeResult: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.succeeded, forKey: "succeeded")
        aCoder.encodeObject(self.returnedValue, forKey: "returnedValue")
        aCoder.encodeDouble(self.executedAt.timeIntervalSince1970, forKey: "executedAt")
        aCoder.encodeObject(self.errorMessage, forKey: "errorMessage")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.succeeded = aDecoder.decodeBoolForKey("succeeded")
        self.returnedValue = aDecoder.decodeObjectForKey("returnedValue") as? String
        self.executedAt = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("executedAt"))
        self.errorMessage = aDecoder.decodeObjectForKey("errorMessage") as? String
        // TODO: add aditional decoder
    }
    
    /** Whether the invocation succeeded */
    public var succeeded: Bool
    /** Returned value from server code */
    public var returnedValue: String?
    /** Date of the execution */
    public var executedAt: NSDate
    /** Error message of the invocation if any */
    public var errorMessage: String?
    
    
    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter succeeded: Whether the invocation succeeded
     - Parameter returnedValue: Returned value from server code
     - Parameter executedAt: Date of the execution
     - Parameter errorMessage: Error message of the invocation if any
     */
    public init(succeeded: Bool, returnedValue: String?, executedAt: NSDate, errorMessage: String?) {
        self.succeeded = succeeded
        self.returnedValue = returnedValue
        self.executedAt = executedAt
        self.errorMessage = errorMessage
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aResult = object as? TriggeredServerCodeResult else{
            return false
        }
        return self.succeeded == aResult.succeeded &&
            self.returnedValue == aResult.returnedValue &&
            self.executedAt == aResult.executedAt &&
            self.errorMessage == aResult.errorMessage
    }

    
    class func resultWithNSDict(resultDict: NSDictionary) -> TriggeredServerCodeResult?{
        let succeeded = resultDict["succeeded"] as? Bool
        let returnedValue = resultDict["returnedValue"] as? String
        let executedAtStamp = resultDict["executedAt"] as? NSNumber
        let errorMessage = resultDict["errorMessage"] as? String

        let executedAt = NSDate(timeIntervalSince1970: (executedAtStamp?.doubleValue)!/1000.0)
        
        var result: TriggeredServerCodeResult?
        if succeeded != nil {
            result = TriggeredServerCodeResult(succeeded:succeeded!, returnedValue:returnedValue, executedAt:executedAt, errorMessage:errorMessage)
        }
        return result
    }

}