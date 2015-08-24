//
//  Clause.swift
//  IoTCloudSDK
//
import Foundation

/** Protocole of the Clause must be conformed to. */
public protocol Clause {
    func toNSDictionary() -> NSDictionary
}

/** Class represents Equals clause. */
public class Equals: Clause {
    var nsdict = NSMutableDictionary()

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
public class NotEquals: Clause {
    var equalClause: Equals!

    public init(equalStmt: Equals) {
        equalClause = equalStmt
    }
    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:String) {
        equalClause = Equals(field: field, value: value)
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        equalClause = Equals(field: field, value: value)
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        equalClause = Equals(field: field, value: value)
    }
    /** Get Clause as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "not", "clause": equalClause.toNSDictionary()])
    }
}

/** Class represents Range clause. */
public class Range: Clause {
    var nsdict: NSMutableDictionary = ["type": "range"]

    /** Initialize with Int left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    init(field:String, lowerLimit:Int, lowerIncluded: Bool) {
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
    init(field:String, lowerLimit:Double, lowerIncluded: Bool) {
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
    init(field:String, upperLimit:Int, upperIncluded: Bool) {
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
    init(field:String, upperLimit:Double, upperIncluded: Bool) {
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
    init(field:String, lowerLimit: Int, lowerIncluded: Bool, upperLimit: Int, upperIncluded: Bool) {
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
    init(field:String, lowerLimit: Double, lowerIncluded: Bool, upperLimit: Double, upperIncluded: Bool) {
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
public class And: Clause {
    var clauseClauseDicts = NSMutableArray()

    /** Initialize with clause clauses.
    - Parameter clauses: Clause instances for AND clauses
    */
    public init(clauses: Clause...) {
        for clause in clauses {
            self.clauseClauseDicts.addObject(clause.toNSDictionary())
        }
    }

    public func add(clause: Clause) {
        self.clauseClauseDicts.addObject(clause.toNSDictionary())
    }

    /** Get Clause as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "and", "clauses": self.clauseClauseDicts])
    }
}
/** Class represents Or clause. */
public class Or: Clause {
    var clauseClauseDicts = NSMutableArray()

    /** Initialize with clause clauses.
    - Parameter clauses: Clause instances for OR clauses
    */
    public init(clauses:Clause...) {
        for clause in clauses {
            clauseClauseDicts.addObject(clause.toNSDictionary())
        }
    }
    public func add(clause: Clause) {
        self.clauseClauseDicts.addObject(clause.toNSDictionary())
    }
    /** Get Clause as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "or", "clauses": self.clauseClauseDicts])
    }
}