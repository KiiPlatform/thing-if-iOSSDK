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
open class EqualsClause: NSObject, Clause {
    private var nsdict = NSMutableDictionary()

    override init() {
        nsdict.setObject("eq", forKey: "type" as NSCopying)
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter string: Left hand side value to be compared.
     */
    public convenience init(field:String, stringValue:String) {
        self.init()
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(stringValue, forKey: "value" as NSCopying)
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter integer: Left hand side value to be compared.
    */
    public convenience init(field:String, intValue:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: intValue as Int), forKey: "value" as NSCopying)
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter bool: Left hand side value to be compared.
    */
    public convenience init(field:String, boolValue:Bool) {
        self.init()
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: boolValue as Bool), forKey: "value" as NSCopying)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init();
        nsdict.addEntries(from: aDecoder.decodeObject() as! [AnyHashable: Any])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encodeRootObject(self.nsdict)
    }

    /** Get Clause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    open func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotEquals clause. */
open class NotEqualsClause: NSObject, Clause {
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

    open func encode(with aCoder: NSCoder) {
        aCoder.encodeRootObject(equalClause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    open func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "not", "clause": equalClause.toNSDictionary()])
    }
}

/** Class represents Range clause. */
open class RangeClause: NSObject, Clause {
    private var nsdict: NSMutableDictionary = ["type": "range"]

    /** Initialize with Int left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitInt:Int, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: lowerLimitInt as Int), forKey: "lowerLimit" as NSCopying)
    }

    /** Initialize with Double left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitDouble:Double, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: lowerLimitDouble as Double), forKey: "lowerLimit" as NSCopying)
    }

    /** Initialize with Int left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.    
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitInt:Int, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: upperLimitInt as Int), forKey: "upperLimit" as NSCopying)
    }

    /** Initialize with Double left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitDouble:Double, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: upperLimitDouble as Double), forKey: "upperLimit" as NSCopying)
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
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: lowerLimitInt as Int), forKey: "lowerLimit" as NSCopying)
        nsdict.setObject(upperIncluded, forKey: "upperIncluded" as NSCopying)
        nsdict.setObject(NSNumber(value: upperLimit as Int), forKey: "upperLimit" as NSCopying)
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
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded" as NSCopying)
        nsdict.setObject(field, forKey: "field" as NSCopying)
        nsdict.setObject(NSNumber(value: lowerLimitDouble as Double), forKey: "lowerLimit" as NSCopying)
        nsdict.setObject(upperIncluded, forKey: "upperIncluded" as NSCopying)
        nsdict.setObject(NSNumber(value: upperLimit as Double), forKey: "upperLimit" as NSCopying)
    }

    public required init(coder aDecoder: NSCoder) {
        nsdict.addEntries(from: aDecoder.decodeObject() as! [AnyHashable: Any])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encodeRootObject(nsdict)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    open func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents And clause. */
open class AndClause: NSObject, Clause {
    /** clauses array of AndClause */
    open private(set) var clauses = [Clause]()

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

    open func encode(with aCoder: NSCoder) {
        let array = NSMutableArray()
        for c in self.clauses {
            array.add(c)
        }
        aCoder.encode(array)
    }

    /** Add clause to AndClause
    
    - Parameter clause: Clause instances to add
    */
    open func add(_ clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    open func toNSDictionary() -> NSDictionary {
        var clauseDictArray = [NSDictionary]()
        for clause in self.clauses {
            clauseDictArray.append(clause.toNSDictionary())
        }

        return NSDictionary(dictionary: ["type": "and", "clauses": clauseDictArray])
    }
}
/** Class represents Or clause. */
open class OrClause: NSObject, Clause {
    /** clauses array of OrClause */
    open private(set) var clauses = [Clause]()

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

    open func encode(with aCoder: NSCoder) {
        let array = NSMutableArray()
        for c in self.clauses {
            array.add(c)
        }
        aCoder.encode(array)
    }

    /** Add clause to OrClause
    
    - Parameter clause: Clause instances to add
    */
    open func add(_ clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    open func toNSDictionary() -> NSDictionary {
        var clauseDictArray = [NSDictionary]()
        for clause in self.clauses {
            clauseDictArray.append(clause.toNSDictionary())
        }
        return NSDictionary(dictionary: ["type": "or", "clauses": clauseDictArray])
    }
}
