//
//  Clause.swift
//  ThingIFSDK
//
import Foundation

/** Protocole of the Clause must be conformed to. */
public protocol Clause: NSCoding {

    /** Get Clause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    func toNSDictionary() -> NSDictionary
}

/** Class represents Equals clause. */
public class EqualsClause: NSObject, Clause {
    private var nsdict = NSMutableDictionary()

    override init() {
        nsdict.setObject("eq", forKey: "type")
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter string: Left hand side value to be compared.
     */
    public convenience init(field:String, stringValue:String) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(stringValue, forKey: "value")
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter integer: Left hand side value to be compared.
    */
    public convenience init(field:String, intValue:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: intValue), forKey: "value")
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter bool: Left hand side value to be compared.
    */
    public convenience init(field:String, boolValue:Bool) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(bool: boolValue), forKey: "value")
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init();
        nsdict.addEntriesFromDictionary(aDecoder.decodeObject() as! [NSObject : AnyObject])
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeRootObject(self.nsdict)
    }

    /** Get Clause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotEquals clause. */
public class NotEqualsClause: NSObject, Clause {
    private var equalClause: EqualsClause!

    public init(equalStmt: EqualsClause) {
        equalClause = equalStmt
    }

    /** Initialize with String left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter string: Left hand side value to be compared.
    */
    public init(field:String, stringValue:String) {
        equalClause = EqualsClause(field: field, stringValue: stringValue)
    }

    /** Initialize with Int left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter integer: Left hand side value to be compared.
    */
    public init(field:String, intValue:Int) {
        equalClause = EqualsClause(field: field, intValue: intValue)
    }

    /** Initialize with Bool left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter bool: Left hand side value to be compared.
    */
    public init(field:String, boolValue:Bool) {
        equalClause = EqualsClause(field: field, boolValue: boolValue)
    }

    public required init(coder aDecoder: NSCoder) {
        equalClause = aDecoder.decodeObject() as! EqualsClause
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeRootObject(equalClause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "not", "clause": equalClause.toNSDictionary()])
    }
}

/** Class represents Range clause. */
public class RangeClause: NSObject, Clause {
    private var nsdict: NSMutableDictionary = ["type": "range"]

    /** Initialize with Int left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitInt:Int, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: lowerLimitInt), forKey: "lowerLimit")
    }

    /** Initialize with Double left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitDouble:Double, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: lowerLimitDouble), forKey: "lowerLimit")
    }

    /** Initialize with Int left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.    
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitInt:Int, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: upperLimitInt), forKey: "upperLimit")
    }

    /** Initialize with Double left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitDouble:Double, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: upperLimitDouble), forKey: "upperLimit")
    }

    /** Initialize with Range.
    this works in the following cases:
    - ">(greater than) and <(less than)" if lower included is false and upper included is false.
    - ">=(greater than or equals) and <(less than)" if lower included is true and upper included is false.
    - ">(greater than) and <=(less than and equals)" if lower included is false and upper included is true.
    - ">=(greater than and equals) and <=(less than and equals)" if lower included is true and upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, lowerLimitInt: Int, lowerIncluded: Bool, upperLimit: Int, upperIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: lowerLimitInt), forKey: "lowerLimit")
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(NSNumber(integer: upperLimit), forKey: "upperLimit")
    }

    /** Initialize with Range.
    this works in the following cases: 
    - ">(greater than) and <(less than)" if lower included is false and upper included is false.
    - ">=(greater than or equals) and <(less than)" if lower included is true and upper included is false.
    - ">(greater than) and <=(less than and equals)" if lower included is false and upper included is true. 
    - ">=(greater than and equals) and <=(less than and equals)" if lower included is true and upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, lowerLimitDouble: Double, lowerIncluded: Bool, upperLimit: Double, upperIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: lowerLimitDouble), forKey: "lowerLimit")
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(NSNumber(double: upperLimit), forKey: "upperLimit")
    }

    public required init(coder aDecoder: NSCoder) {
        nsdict.addEntriesFromDictionary(aDecoder.decodeObject() as! [NSObject : AnyObject])
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeRootObject(nsdict)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents And clause. */
public class AndClause: NSObject, Clause {
    /** clauses array of AndClause */
    public private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.
    
    - Parameter clauses: Clause instances for AND clauses
    */
    public init(clauses: Clause...) {
        for clause in clauses {
            self.clauses.append(clause)
        }
    }

    public required init(coder aDecoder: NSCoder) {
        let array = aDecoder.decodeObject() as! NSArray
        for clause in array as [AnyObject] {
            self.clauses.append(clause as! Clause)
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        let array = NSMutableArray()
        for c in self.clauses {
            array.addObject(c)
        }
        aCoder.encodeObject(array)
    }

    /** Add clause to AndClause
    
    - Parameter clause: Clause instances to add
    */
    public func add(clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        var clauseDictArray = [NSDictionary]()
        for clause in self.clauses {
            clauseDictArray.append(clause.toNSDictionary())
        }

        return NSDictionary(dictionary: ["type": "and", "clauses": clauseDictArray])
    }
}
/** Class represents Or clause. */
public class OrClause: NSObject, Clause {
    /** clauses array of OrClause */
    public private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.
    
    - Parameter clauses: Clause instances for OR clauses
    */
    public init(clauses:Clause...) {
        for clause in clauses {
            self.clauses.append(clause)
        }
    }

    public required init(coder aDecoder: NSCoder) {
        let array = aDecoder.decodeObject() as! NSArray
        for clause in array as [AnyObject] {
            self.clauses.append(clause as! Clause)
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        let array = NSMutableArray()
        for c in self.clauses {
            array.addObject(c)
        }
        aCoder.encodeObject(array)
    }

    /** Add clause to OrClause
    
    - Parameter clause: Clause instances to add
    */
    public func add(clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        var clauseDictArray = [NSDictionary]()
        for clause in self.clauses {
            clauseDictArray.append(clause.toNSDictionary())
        }
        return NSDictionary(dictionary: ["type": "or", "clauses": clauseDictArray])
    }
}