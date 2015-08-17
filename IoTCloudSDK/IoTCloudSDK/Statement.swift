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
    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotEquals statement. */
public class NotEquals: Statement {
    var clauseNSDict = NSMutableDictionary()
    var stmtNSDict: NSDictionary!

    init() {
        stmtNSDict = NSDictionary(dictionary: ["type": "not", "clause": clauseNSDict])
    }
    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(field:String, value:String) {
        self.init()
        clauseNSDict.setObject(field, forKey: "field")
        clauseNSDict.setObject(value, forKey: "value")
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(field:String, value:Int) {
        self.init()
        clauseNSDict.setObject(field, forKey: "field")
        clauseNSDict.setObject(NSNumber(integer: value), forKey: "value")
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(field:String, value:Bool) {
        self.init()
        clauseNSDict.setObject(field, forKey: "field")
        clauseNSDict.setObject(NSNumber(bool: value), forKey: "value")
    }
    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return stmtNSDict
    }
}

/** Class represents GreaterThan statement. */
public class GreaterThan: Statement {
    var nsdict = NSMutableDictionary()

    init() {
        nsdict.setObject("range", forKey: "type")
        nsdict.setObject(false, forKey: "lowerIncluded")
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Lower limit value.
    */
    public convenience init(field:String, value:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: value), forKey: "value")
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return nsdict
    }
}

/** Class represents LessThan statement. */
public class LessThan: Statement {
    var nsdict = NSMutableDictionary()

    init() {
        nsdict.setObject("range", forKey: "type")
        nsdict.setObject(false, forKey: "upperIncluded")
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimit: Upper limit value.
    */
    public convenience init(field:String, upperLimit:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: upperLimit), forKey: "upperLimit")
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotGreaterThan statement. */
public class NotGreaterThan: Statement {
    var nsdict = NSMutableDictionary()

    init() {
        nsdict.setObject("range", forKey: "type")
        nsdict.setObject(true, forKey: "upperIncluded")
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimit: Upper limit value.
    */
    public convenience init(field:String, upperLimit:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: upperLimit), forKey: "upperLimit")
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: nsdict)
    }
}

/** Class represents NotLessThan statement. */
public class NotLessThan: Statement {
    var nsdict = NSMutableDictionary()

    init() {
        nsdict.setObject("range", forKey: "type")
        nsdict.setObject(true, forKey: "lowerIncluded")
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimit: Lower limit value.
    */
    public convenience init(field:String, lowerLimit:Int) {
        self.init()
        nsdict.setObject(field, forKey: "field")
        nsdict.setObject(NSNumber(integer: lowerLimit), forKey: "lowerLimit")
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
    var clauseDictArray: NSMutableArray

    /** Initialize with clause statements.
    - Parameter statements: Statement instances for OR clauses
    */
    public init(statements:Statement...) {
        self.clauseDictArray = NSMutableArray()
        for statement in statements {
            clauseDictArray.addObject(statement.toNSDictionary())
        }
    }

    /** Get Statement as NSDictionary instance
    - Returns: a NSDictionary instance.
    */
    public func toNSDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["type": "or", "clauses": self.clauseDictArray])
    }
}