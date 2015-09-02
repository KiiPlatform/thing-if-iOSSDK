//
//  Clause.swift
//  IoTCloudSDK
//
import Foundation

/** Protocole of the Clause must be conformed to. */
public protocol Clause {

    /** Get Clause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    func toNSDictionary() -> NSDictionary
}

/** Class represents Equals clause. */
public class EqualsClause: Clause {
    private var nsdict = NSMutableDictionary()

    init() {
        nsdict.setObject("eq", forKey: "type")
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
     */
    public convenience init(field:String, value:String) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(value, forKey: "value")
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(field:String, value:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: value), forKey: "value")
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(field:String, value:Bool) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(bool: value), forKey: "value")
    }

    /** Get Clause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotEquals clause. */
public class NotEqualsClause: Clause {
    private var equalClause: EqualsClause!

    public init(equalStmt: EqualsClause) {
        equalClause = equalStmt
    }

    /** Initialize with String left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:String) {
        equalClause = EqualsClause(field: field, value: value)
    }

    /** Initialize with Int left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        equalClause = EqualsClause(field: field, value: value)
    }

    /** Initialize with Bool left hand side value.
    
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        equalClause = EqualsClause(field: field, value: value)
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "not", "clause": equalClause.toNSDictionary()])
    }
}

/** Class represents Range clause. */
public class RangeClause: Clause {
    private var nsdict: NSMutableDictionary = ["type": "range"]

    /** Initialize with Int left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimit:Int, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: lowerLimit), forKey: "lowerLimit")
    }

    /** Initialize with Double left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimit:Double, lowerIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: lowerLimit), forKey: "lowerLimit")
    }

    /** Initialize with Int left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.    
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimit:Int, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: upperLimit), forKey: "upperLimit")
    }

    /** Initialize with Double left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimit:Double, upperIncluded: Bool) {
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: upperLimit), forKey: "upperLimit")
    }

    /** Initialize with Range.
    this works in the following cases:
    - ">(greater than) and <(less than)" if lower included is false and upper included is false.
    - ">=(greater than or equals) and <(less than)" if lower included is true and upper included is false.
    - ">(greater than) and <=(less than and equals)" if lower included is false and upper included is true.
    - ">=(greater than and equals) and <=(less than and equals)" if lower included is true and upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, lowerLimit: Int, lowerIncluded: Bool, upperLimit: Int, upperIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: lowerLimit), forKey: "lowerLimit")
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
    - Parameter lowerLimit: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, lowerLimit: Double, lowerIncluded: Bool, upperLimit: Double, upperIncluded: Bool) {
        nsdict.setObject(lowerIncluded, forKey: "lowerIncluded")
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(double: lowerLimit), forKey: "lowerLimit")
        nsdict.setObject(upperIncluded, forKey: "upperIncluded")
        nsdict.setObject(NSNumber(double: upperLimit), forKey: "upperLimit")
    }

    /** Get Clause as NSDictionary instance
    
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents And clause. */
public class AndClause: Clause {
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
public class OrClause: Clause {
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