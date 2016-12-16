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
    func makeDictionary() -> [ String : Any ]
}

/** Class represents Equals clause. */
open class EqualsClause<ConcreteAlias: Alias>: NSObject, Clause {

    private let alias: ConcreteAlias
    private let field: String
    private let value: AnyObject

    private init(_ alias: ConcreteAlias, _ field: String, _ value: AnyObject) {
        self.alias = alias
        self.field = field
        self.value = value
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
     */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: Int)
    {
        self.init(alias, field, value as AnyObject)
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: String)
    {
        self.init(alias, field, value as AnyObject)
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: Bool)
    {
        self.init(alias, field, value as AnyObject)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "alias") as! ConcreteAlias,
                  aDecoder.decodeObject(forKey: "field") as! String,
                  aDecoder.decodeObject(forKey: "value") as AnyObject)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alias, forKey: "alias")
        aCoder.encode(self.field, forKey: "field")
        if self.value is Int {
            aCoder.encode(self.value as! Int, forKey: "value")
        } else if self.value is String {
            aCoder.encode(self.value as! String, forKey: "value")
        } else if self.value is Bool {
            aCoder.encode(self.value as! Bool, forKey: "value")
        }
    }

    /** Get Clause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var retval: [String : Any] = [
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ]
        self.alias.makeDictionary().forEach { (k, v) in retval[k] = v}
        return retval
    }
}

/** Class represents NotEquals clause. */
open class NotEqualsClause<ConcreteAlias: Alias>: NSObject, Clause {
    private let equalClause: EqualsClause<ConcreteAlias>

    public init(_ equalClause: EqualsClause<ConcreteAlias>) {
        self.equalClause = equalClause
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: String)
    {
        self.init(EqualsClause(alias, field, value))
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: Int)
    {
        self.init(EqualsClause(alias, field, value))
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: ConcreteAlias,
      _ field: String,
      _ value: Bool)
    {
        self.init(EqualsClause(alias, field, value))
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! EqualsClause)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.equalClause)
    }

    /** Get Clause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "type": "not",
          "clause": equalClause.makeDictionary()
        ] as [ String : Any ]
    }
}

/** Class represents Range clause. */
open class RangeClause: NSObject, Clause {
    private var nsdict:[ String : Any ] = ["type": "range"]

    /** Initialize with Int left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitInt:Int, lowerIncluded: Bool) {
        self.nsdict["lowerIncluded"] = lowerIncluded
        self.nsdict["field"] = field
        self.nsdict["lowerLimit"] = NSNumber(value: lowerLimitInt as Int)
    }

    /** Initialize with Double left hand side value.
    this works as >(greater than) if lower included is false and as >=(greater than or equals) if lower included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public init(field:String, lowerLimitDouble:Double, lowerIncluded: Bool) {
        self.nsdict["lowerIncluded"] = lowerIncluded
        self.nsdict["field"] = field
        self.nsdict["lowerLimit"] = NSNumber(value: lowerLimitDouble as Double)
    }

    /** Initialize with Int left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.    
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitInt:Int, upperIncluded: Bool) {
        self.nsdict["upperIncluded"] = upperIncluded
        self.nsdict["field"] = field
        self.nsdict["upperLimit"] = NSNumber(value: upperLimitInt as Int)
    }

    /** Initialize with Double left hand side value.
    this works as <(less than) if upper included is false and as <=(less than or equals) if upper included is true.
    
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public init(field:String, upperLimitDouble:Double, upperIncluded: Bool) {
        self.nsdict["upperIncluded"] = upperIncluded
        self.nsdict["field"] = field
        self.nsdict["upperLimit"] = NSNumber(value: upperLimitDouble as Double)
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
        self.nsdict["lowerIncluded"] = lowerIncluded
        self.nsdict["field"] = field
        self.nsdict["lowerLimit"] = NSNumber(value: lowerLimitInt as Int)
        self.nsdict["upperIncluded"] = upperIncluded
        self.nsdict["upperLimit"] = NSNumber(value: upperLimit as Int)
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
        self.nsdict["lowerIncluded"] = lowerIncluded
        self.nsdict["field"] = field
        self.nsdict["lowerLimit"] = NSNumber(value: lowerLimitDouble as Double)
        self.nsdict["upperIncluded"] = upperIncluded
        self.nsdict["upperLimit"] = NSNumber(value: upperLimit as Double)
    }

    public required init(coder aDecoder: NSCoder) {
        self.nsdict = aDecoder.decodeObject() as! [ String: Any ]
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encodeRootObject(nsdict)
    }

    /** Get Clause as [ String : Any ] instance
    
    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        return self.nsdict as [ String : Any ]
    }
}

/** Class represents And clause. */
open class AndClause: NSObject, Clause {
    /** clauses array of AndClause */
    open private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.
    
    - Parameter clauses: Clause instances for AND clauses
    */
    public convenience init(clauses: Clause...) {
        self.init(clauses: clauses)
    }

    /** Initialize with clause clauses.
    
     - Parameter clauses: Clause array for AND clauses
     */
    public init(clauses: [Clause]) {
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

    /** Get Clause as [ String : Any ] instance
    
    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var clauseDictArray = [[ String : Any ]]()
        for clause in self.clauses {
            clauseDictArray.append(clause.makeDictionary())
        }

        return  ["type": "and", "clauses": clauseDictArray] as [ String : Any ]
    }
}
/** Class represents Or clause. */
open class OrClause: NSObject, Clause {
    /** clauses array of OrClause */
    open private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.
    
    - Parameter clauses: Clause instances for OR clauses
    */
    public convenience init(clauses:Clause...) {
        self.init(clauses: clauses)
    }

    /** Initialize with clause clauses.
    
     - Parameter clauses: Clause array for OR clauses
     */
    public init(clauses: [Clause]) {
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

    /** Get Clause as [ String : Any ] instance
    
    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var clauseDictArray = [[ String : Any ]]()
        for clause in self.clauses {
            clauseDictArray.append(clause.makeDictionary())
        }
        return ["type": "or", "clauses": clauseDictArray] as [ String : Any ]
    }
}
