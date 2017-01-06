//
//  TriggerClause.swift
//  ThingIFSDK
//
import Foundation

/** Base class of any clauses class.

 Developers can not instantiate this class directly. Developers use
 sub classes of this class
 */
public protocol TriggerClause: NSCoding {

    /** Get TriggerClause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    func makeDictionary() -> [ String : Any ]

}

/** Class represents Equals clause. */
open class EqualsTriggerClause: NSObject, TriggerClause {

    private let alias: String
    private let field: String
    private let value: AnyObject

    private init(_ alias: String, _ field: String, _ value: AnyObject) {
        self.alias = alias
        self.field = field
        self.value = value
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
     */
    public convenience init(
      _ alias: String,
      _ field: String,
      intValue: Int)
    {
        self.init(alias, field, intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: String,
      _ field: String,
      stringValue: String)
    {
        self.init(alias, field, stringValue as AnyObject)
    }

    /** Initialize with Bool left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: String,
      _ field: String,
      boolValue: Bool)
    {
        self.init(alias, field, boolValue as AnyObject)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "alias") as! String,
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

    /** Get TriggerClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "alias" : self.alias,
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }
}

/** Class represents NotEquals clause. */
open class NotEqualsTriggerClause: NSObject, TriggerClause {
    private let equalClause: EqualsTriggerClause

    public init(_ equalClause: EqualsTriggerClause) {
        self.equalClause = equalClause
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: String,
      _ field: String,
      stringValue: String)
    {
        self.init(EqualsTriggerClause(alias, field, stringValue: stringValue))
    }

    /** Initialize with Int left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: String,
      _ field: String,
      intValue: Int)
    {
        self.init(EqualsTriggerClause(alias, field, intValue: intValue))
    }

    /** Initialize with Bool left hand side value.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    */
    public convenience init(
      _ alias: String,
      _ field: String,
      boolValue: Bool)
    {
        self.init(EqualsTriggerClause(alias, field, boolValue: boolValue))
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! EqualsTriggerClause)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.equalClause)
    }

    /** Get TriggerClause as [ String : Any ] instance

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
open class RangeTriggerClause: NSObject, TriggerClause {
    private let alias: String
    private let field: String
    private let lower: (included: Bool, limit: AnyObject)?
    private let upper: (included: Bool, limit: AnyObject)?

    private init(
      _ alias: String,
      _ field: String,
      lower: (included: Bool, limit: AnyObject)? = nil,
      upper: (included: Bool, limit: AnyObject)? = nil)
    {
        self.alias = alias
        self.field = field
        self.lower = lower
        self.upper = upper
        super.init()
    }

    /** Initialize with Int left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      lowerLimitInt:Int,
      lowerIncluded: Bool)
    {
        self.init(
          alias,
          field,
          lower: (included: lowerIncluded, limit: lowerLimitInt as AnyObject))
    }

    /** Initialize with Double left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      lowerLimitDouble:Double,
      lowerIncluded: Bool)
    {
        self.init(
          alias,
          field,
          lower: (
            included: lowerIncluded,
            limit: lowerLimitDouble as AnyObject
          )
        )
    }

    /** Initialize with Int left hand side value.

    This works as <(less than) if upper included is false and as
    <=(less than or equals) if upper included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      upperLimitInt:Int,
      upperIncluded: Bool)
    {
        self.init(
          alias,
          field,
          upper: (included: upperIncluded, limit: upperLimitInt as AnyObject))
    }

    /** Initialize with Double left hand side value.

    This works as <(less than) if upper included is false and as
    <=(less than or equals) if upper included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      upperLimitDouble:Double,
      upperIncluded: Bool)
    {
        self.init(
          alias,
          field,
          upper: (
            included: upperIncluded,
            limit: upperLimitDouble as AnyObject
          )
        )
    }

    /** Initialize with Range.

    This works in the following cases:
    - ">(greater than) and <(less than)" if lower included is false
      and upper included is false.
    - ">=(greater than or equals) and <(less than)" if lower included
      is true and upper included is false.
    - ">(greater than) and <=(less than and equals)" if lower included
      is false and upper included is true.
    - ">=(greater than and equals) and <=(less than and equals)" if
      lower included is true and upper included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      lowerLimitInt: Int,
      lowerIncluded: Bool,
      upperLimitInt: Int,
      upperIncluded: Bool)
    {
        self.init(
          alias,
          field,
          lower: (included: lowerIncluded, limit: lowerLimitInt as AnyObject),
          upper: (included: upperIncluded, limit: upperLimitInt as AnyObject))
    }

    /** Initialize with Range.

    This works in the following cases:
    - ">(greater than) and <(less than)" if lower included is false
      and upper included is false.
    - ">=(greater than or equals) and <(less than)" if lower included
      is true and upper included is false.
    - ">(greater than) and <=(less than and equals)" if lower included
      is false and upper included is true.
    - ">=(greater than and equals) and <=(less than and equals)" if
      lower included is true and upper included is true.

    - Parameter alias: Alias of trait.
    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ alias: String,
      _ field:String,
      lowerLimitDouble: Double,
      lowerIncluded: Bool,
      upperLimitDouble: Double,
      upperIncluded: Bool)
    {
        self.init(
          alias,
          field,
          lower: (
            included: lowerIncluded,
            limit: lowerLimitDouble as AnyObject
          ),
          upper: (
            included: upperIncluded,
            limit: upperLimitDouble as AnyObject
          )
        )
    }

    public required convenience init(coder aDecoder: NSCoder) {
        let lower: (included: Bool, limit: AnyObject)?
        if let dict = aDecoder.decodeObject(forKey: "lower")
             as? [String : Any] {
            lower = (dict["included"] as! Bool, dict["limit"] as AnyObject)
        } else {
            lower = nil
        }

        let upper: (included: Bool, limit: AnyObject)?
        if let dict = aDecoder.decodeObject(forKey: "upper")
             as? [String : Any] {
            upper = (dict["included"] as! Bool, dict["limit"] as AnyObject)
        } else {
            upper = nil
        }

        self.init(
          aDecoder.decodeObject(forKey: "alias") as! String,
          aDecoder.decodeObject(forKey: "field") as! String,
          lower: lower,
          upper: upper)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alias, forKey: "alias")
        aCoder.encode(self.field, forKey: "field")
        if let lower = self.lower {
            aCoder.encode(
              [
                "included" : lower.included,
                "limit" : lower.limit
              ] as [String : Any], forKey: "lower")
        }
        if let upper = self.upper {
            aCoder.encode(
              [
                "included" : upper.included,
                "limit" : upper.limit
              ] as [String : Any], forKey: "upper")
        }
    }

    /** Get TriggerClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var retval = [
          "alias" : self.alias,
          "type" : "range",
          "field" : self.field
        ] as [String : Any]

        if let lower = self.lower {
            retval["lowerLimit"] = lower.limit as Any
            retval["lowerIncluded"] = lower.included
        }
        if let upper = self.upper {
            retval["upperLimit"] = upper.limit as Any
            retval["upperIncluded"] = upper.included
        }
        return retval
    }
}

/** Class represents And clause. */
open class AndTriggerClause: NSObject, TriggerClause {
    /** clauses array of AndTriggerClause */
    open private(set) var clauses = [TriggerClause]()

    /** Initialize with clause clauses.

    - Parameter clauses: TriggerClause instances for AND clauses
    */
    public convenience init(_ clauses: TriggerClause...) {
        self.init(clauses)
    }

    /** Initialize with clause clauses.

     - Parameter clauses: TriggerClause array for AND clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
        super.init()
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [TriggerClause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to AndTriggerClause

    - Parameter clause: TriggerClause instances to add
    */
    open func add(_ clause: TriggerClause) {
        self.clauses.append(clause)
    }

    /** Get TriggerClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "and", "clauses": array] as [ String : Any ]
    }
}

/** Class represents Or clause. */
open class OrTriggerClause: NSObject, TriggerClause {
    /** clauses array of OrTriggerClause */
    open private(set) var clauses = [TriggerClause]()

    /** Initialize with clause clauses.

     - Parameter clauses: TriggerClause array for OR clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
        super.init()
    }

    /** Initialize with clause clauses.

    - Parameter clauses: TriggerClause instances for OR clauses
    */
    public convenience init(_ clauses: TriggerClause...) {
        self.init(clauses)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [TriggerClause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to OrTriggerClause

    - Parameter clause: TriggerClause instances to add
    */
    open func add(_ clause: TriggerClause) {
        self.clauses.append(clause)
    }

    /** Get TriggerClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "or", "clauses": array] as [ String : Any ]
    }
}
