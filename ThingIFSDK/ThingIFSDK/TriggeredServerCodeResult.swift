import Foundation

/** Class represents result of server code trigged by trigger */
public class TriggeredServerCodeResult: NSObject, NSCoding {
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(self.succeeded, forKey: "succeeded")
        aCoder.encodeObject(self.returnedValue, forKey: "returnedValue")
        aCoder.encodeDouble(self.executedAt.timeIntervalSince1970, forKey: "executedAt")
        aCoder.encodeObject(self.error, forKey: "error")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.succeeded = aDecoder.decodeBoolForKey("succeeded")
        self.returnedValue = aDecoder.decodeObjectForKey("returnedValue") as AnyObject?
        self.executedAt = NSDate(timeIntervalSince1970: aDecoder.decodeDoubleForKey("executedAt"))
        self.error = aDecoder.decodeObjectForKey("error") as? Dictionary<String, AnyObject>
        // TODO: add aditional decoder
    }
    
    /** Whether the invocation succeeded */
    public var succeeded: Bool
    /** Returned value from server code (JsonObject, JsonArray, String, Number, Boolean or null) */
    public var returnedValue: AnyObject?
    /** Date of the execution */
    public var executedAt: NSDate
    /** Error object of the invocation if any */
    public var error: Dictionary<String, AnyObject>?
    
    
    /** Init TriggeredServerCodeResult with necessary attributes
     
     - Parameter succeeded: Whether the invocation succeeded
     - Parameter returnedValue: Returned value from server code
     - Parameter executedAt: Date of the execution
     - Parameter error: Error object of the invocation if any
     */
    public init(succeeded: Bool, returnedValue: AnyObject?, executedAt: NSDate, error: Dictionary<String, AnyObject>?) {
        self.succeeded = succeeded
        self.returnedValue = returnedValue
        self.executedAt = executedAt
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
        if let bool = self.returnedValue as? Bool {
            return bool
        }
        return nil
    }
    public func getReturnedValueAsNSNumber() -> NSNumber? {
        if let num = self.returnedValue as? NSNumber {
            return num
        }
        return nil
    }
    public func getReturnedValueAsDictionary() -> Dictionary<String, AnyObject>? {
        if let dic = self.returnedValue as? Dictionary<String, AnyObject> {
            return dic
        }
        return nil
    }
    public func getReturnedValueAsArray() -> [AnyObject]? {
        if let array = self.returnedValue as? [AnyObject] {
            return array
        }
        return nil
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aResult = object as? TriggeredServerCodeResult else{
            return false
        }
        if self.returnedValue == nil || aResult.returnedValue == nil {
            if self.returnedValue != nil || aResult.returnedValue != nil {
                return false
            }
        }
        if self.returnedValue is Dictionary<String, AnyObject> {
            if !NSDictionary(dictionary: self.returnedValue as! [NSObject : AnyObject]).isEqualToDictionary(aResult.returnedValue as! [NSObject : AnyObject]) {
                return false
            }
        } else if self.returnedValue is [AnyObject] {
            if !isEqualArray(self.returnedValue as! [AnyObject], arr2: aResult.returnedValue as! [AnyObject]) {
                return false
            }
        } else if self.returnedValue is String {
            if self.returnedValue as! String != aResult.returnedValue as! String {
                return false
            }
        } else if self.returnedValue is Bool {
            if self.returnedValue as! Bool != aResult.returnedValue as! Bool {
                return false
            }
        } else if self.returnedValue is NSNumber {
            if self.returnedValue as! NSNumber != aResult.returnedValue as! NSNumber {
                return false
            }
        }
        if self.error == nil || aResult.error == nil {
            if self.error != nil || aResult.error != nil {
                return false
            }
        } else if (!NSDictionary(dictionary: self.error!).isEqualToDictionary(aResult.error!)) {
            return false
        }
        return self.succeeded == aResult.succeeded && self.executedAt == aResult.executedAt
    }
    private func isEqualArray(arr1:[AnyObject], arr2:[AnyObject]) -> Bool {
        if arr1.count != arr2.count {
            return false
        }
        for var i = 0; i < arr1.count; ++i {
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
            } else if e1 is Bool {
                if e1 as! Bool != e2 as! Bool {
                    return false
                }
            } else if e1 is NSNumber {
                if e1 as! NSNumber != e2 as! NSNumber {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
    
    class func resultWithNSDict(resultDict: NSDictionary) -> TriggeredServerCodeResult?{
        let succeeded = resultDict["succeeded"] as? Bool
        let returnedValue = resultDict["returnedValue"] as AnyObject?
        let executedAtStamp = resultDict["executedAt"] as? NSNumber
        let error = resultDict["error"] as? Dictionary<String, AnyObject>

        let executedAt = NSDate(timeIntervalSince1970: (executedAtStamp?.doubleValue)!/1000.0)
        
        var result: TriggeredServerCodeResult?
        if succeeded != nil {
            result = TriggeredServerCodeResult(succeeded:succeeded!, returnedValue:returnedValue, executedAt:executedAt, error:error)
        }
        return result
    }

}