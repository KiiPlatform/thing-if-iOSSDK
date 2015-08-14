//
//  Statement.swift
//  IoTCloudSDK
//
import Foundation

/** Protocole of the Statement must be conformed to. */
public protocol Statement {
    func toNSDictionary() -> NSDictionary
}

/** Class represents Equals statement. */
public class Equals: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
     */
    public init(field:String, value:String) {
       nsdict.setObject(value, forKey: field)
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        nsdict.setObject(NSNumber(bool: value), forKey: field)
    }
    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["=":nsdict])
    }
}

/** Class represents NotEquals statement. */
public class NotEquals: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:String) {
        nsdict.setObject(value, forKey: field)
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        nsdict.setObject(NSNumber(bool: value), forKey: field)
    }
    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["!=":nsdict])
    }
}

/** Class represents GreaterThan statement. */
public class GreaterThan: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: [">":nsdict])
    }
}

/** Class represents LessThan statement. */
public class LessThan: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["<":nsdict])
    }
}

/** Class represents NotGreaterThan statement. */
public class NotGreaterThan: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["<=":nsdict])
    }
}

/** Class represents NotLessThan statement. */
public class NotLessThan: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: [">=":nsdict])
    }
}

/** Class represents And statement. */
public class And: Statement {
    var statements: NSArray

    /** Initialize with 2 Statements.
    - Parameter statement1: an instance of Statement.
    - Parameter statement2: an instance of Statement.
    */
    public init(statement1:Statement, statement2:Statement) {
        self.statements = NSArray(array: [statement1.toNSDictionary(), statement2.toNSDictionary()])
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["and":self.statements])
    }
}
/** Class represents Or statement. */
public class Or: Statement {
    var statements: NSArray

    /** Initialize with 2 Statements.
    - Parameter statement1: an instance of Statement.
    - Parameter statement2: an instance of Statement.
    */
    public init(statement1:Statement, statement2:Statement) {
        self.statements = NSArray(array: [statement1.toNSDictionary(), statement2.toNSDictionary()])
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["or":self.statements])
    }
}