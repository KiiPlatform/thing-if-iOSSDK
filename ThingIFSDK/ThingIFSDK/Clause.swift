//
//  Clause.swift
//  ThingIFSDK
//
import Foundation

/** Base class of any clauses class.

 Developers can not instantiate this class directly. Developers use
 sub classes of this class
 */
public protocol Clause: NSCoding {

    /** Get Clause as Dictionary instance

    - Returns: a Dictionary instance.
    */
    func makeDictionary() -> [ String : Any ]

}

/** Class represents Equals clause.

 Alias is mandatory for some methods. For the other methods, alias is
 needless.

 Following methods require alias:

 - `ThingIFAPI.postNewTrigger(_:predicate:options:completionHandler:)` for trigger and server code.
 - `ThingIFAPI.patchTrigger(_:triggeredCommandForm:predicate:options:completionHandler:)`
 - `ThingIFAPI.patchTrigger(_:serverCode:predicate:options:completionHandler:)`

 `StatePredicate` has `Condition`. `Condition` has `Clause`. All
 clauses in the condition must have alias property.

 Following methods does not required alias:

 - `ThingIFAPI.query(_:clause:firmwareVersion:bestEffortLimit:nextPaginationKey:completionHandler:)`
 - `ThingIFAPI.query(_:range:clause:firmwareVersion:completionHandler:)`
 _ `ThingIFAPI.count(_:range:field:clause:firmwareVersion:completionHandler:)`
 - `ThingIFAPI.aggregate(_:range:aggregation:clause:firmwareVersion:completionHandler:)`

 Even if these methods receive alias of this class, This SDK ignore
 the property.
 */
open class EqualsClause: NSObject, Clause {

    private let alias: String?
    private let field: String
    private let value: AnyObject

    private init(_ field: String, value: AnyObject, alias: String? = nil) {
        self.field = field
        self.value = value
        self.alias = alias
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
     */
    public convenience init(
      _ field: String,
      intValue: Int,
      alias: String? = nil)
    {
        self.init(field, value: intValue as AnyObject, alias: alias)
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field: String,
      stringValue: String,
      alias: String? = nil)
    {
        self.init(field, value: stringValue as AnyObject, alias: alias)
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field: String,
      boolValue: Bool,
      alias: String? = nil)
    {
        self.init(field, value: boolValue as AnyObject, alias: alias)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "field") as! String,
                  value: aDecoder.decodeObject(forKey: "value") as AnyObject,
                  alias: aDecoder.decodeObject(forKey: "alias") as? String)
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

    /** Get EqualsClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var retval: [String : Any] = [
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ]

        retval["alias"] = self.alias
        return retval

    }
}

/** Class represents NotEquals clause.

 Alias is mandatory for some methods. For the other methods, alias is
 needless.  Please refer `EqualsClause` for the details.
 */
open class NotEqualsClause: NSObject, Clause {
    private let equalClause: EqualsClause

    public init(_ equalClause: EqualsClause) {
        self.equalClause = equalClause
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field: String,
      stringValue: String,
      alias: String? = nil)
    {
        self.init(EqualsClause(field, stringValue: stringValue, alias: alias))
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field: String,
      intValue: Int,
      alias: String? = nil)
    {
        self.init(EqualsClause(field, intValue: intValue, alias: alias))
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field: String,
      boolValue: Bool,
      alias: String? = nil)
    {
        self.init(EqualsClause(field, boolValue: boolValue, alias: alias))
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! EqualsClause)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.equalClause)
    }

    /** Get NotEqualsClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "type": "not",
          "clause": equalClause.makeDictionary()
        ] as [ String : Any ]
    }
}

/** Class represents Range clause.

 Alias is mandatory for some methods. For the other methods, alias is
 needless.  Please refer `EqualsClause` for the details.
 */
open class RangeClause: NSObject, Clause {
    private let alias: String?
    private let field: String
    private let lower: (included: Bool, limit: AnyObject)?
    private let upper: (included: Bool, limit: AnyObject)?

    private init(
      _ field: String,
      lower: (included: Bool, limit: AnyObject)? = nil,
      upper: (included: Bool, limit: AnyObject)? = nil,
      alias: String? = nil)
    {
        self.field = field
        self.lower = lower
        self.upper = upper
        self.alias = alias
        super.init()
    }

    /** Initialize with Int left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      lowerLimitInt:Int,
      lowerIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          lower: (included: lowerIncluded, limit: lowerLimitInt as AnyObject),
          alias: alias)
    }

    /** Initialize with Double left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      lowerLimitDouble:Double,
      lowerIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          lower: (
            included: lowerIncluded,
            limit: lowerLimitDouble as AnyObject
          ),
          alias: alias
        )
    }

    /** Initialize with Int left hand side value.

    This works as <(less than) if upper included is false and as
    <=(less than or equals) if upper included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      upperLimitInt:Int,
      upperIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          upper: (included: upperIncluded, limit: upperLimitInt as AnyObject),
          alias: alias)
    }

    /** Initialize with Double left hand side value.

    This works as <(less than) if upper included is false and as
    <=(less than or equals) if upper included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      upperLimitDouble:Double,
      upperIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          upper: (
            included: upperIncluded,
            limit: upperLimitDouble as AnyObject
          ),
          alias: alias
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

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      lowerLimitInt: Int,
      lowerIncluded: Bool,
      upperLimitInt: Int,
      upperIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          lower: (included: lowerIncluded, limit: lowerLimitInt as AnyObject),
          upper: (included: upperIncluded, limit: upperLimitInt as AnyObject),
          alias: alias)
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

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    - Parameter alias: Alias of trait.
    */
    public convenience init(
      _ field:String,
      lowerLimitDouble: Double,
      lowerIncluded: Bool,
      upperLimitDouble: Double,
      upperIncluded: Bool,
      alias: String? = nil)
    {
        self.init(
          field,
          lower: (
            included: lowerIncluded,
            limit: lowerLimitDouble as AnyObject
          ),
          upper: (
            included: upperIncluded,
            limit: upperLimitDouble as AnyObject
          ),
          alias: alias
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
          aDecoder.decodeObject(forKey: "field") as! String,
          lower: lower,
          upper: upper,
          alias: aDecoder.decodeObject(forKey: "alias") as? String)
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

    /** Get RangeClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var retval = [
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
        retval["alias"] = self.alias
        return retval
    }
}

/** Class represents And clause.

 This clause contains other clauses. If the clauses are
 `EqualsClause`, `NotEqualsClause` and/or `RangeClause`, alias is
 mandatory for some methods and is needless the other methods.
 Please refer `EqualsClause` for the details.
 */
open class AndClause: NSObject, Clause {
    /** clauses array of AndClause */
    open private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.

    - Parameter clauses: Clause instances for AND clauses
    */
    public convenience init(_ clauses: Clause...) {
        self.init(clauses)
    }

    /** Initialize with clause clauses.

     - Parameter clauses: Clause array for AND clauses
     */
    public init(_ clauses: [Clause]) {
        self.clauses = clauses
        super.init()
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [Clause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to AndClause

    - Parameter clause: Clause instances to add
    */
    open func add(_ clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get AndClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "and", "clauses": array] as [ String : Any ]
    }
}

/** Class represents Or clause.

 This clause contains other clauses. If the clauses are
 `EqualsClause`, `NotEqualsClause` and/or `RangeClause`, alias is
 mandatory for some methods and is needless the other methods.
 Please refer `EqualsClause` for the details.
 */
open class OrClause: NSObject, Clause {
    /** clauses array of OrClause */
    open private(set) var clauses = [Clause]()

    /** Initialize with clause clauses.

     - Parameter clauses: Clause array for OR clauses
     */
    public init(_ clauses: [Clause]) {
        self.clauses = clauses
        super.init()
    }

    /** Initialize with clause clauses.

    - Parameter clauses: Clause instances for OR clauses
    */
    public convenience init(_ clauses: Clause...) {
        self.init(clauses)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [Clause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to OrClause

    - Parameter clause: Clause instances to add
    */
    open func add(_ clause: Clause) {
        self.clauses.append(clause)
    }

    /** Get OrClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "or", "clauses": array] as [ String : Any ]
    }
}
