//
//  QueryClause.swift
//  ThingIFSDK
//
//  Created 2016/12/27.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Base class of any clauses class.

 Developers can not instantiate this class directly. Developers use
 sub classes of this class
 */
public protocol QueryClause: NSCoding {

    /** Get QueryClause as NSDictionary instance

    - Returns: a NSDictionary instance.
    */
    func makeDictionary() -> [ String : Any ]

}

/** Class represents Equals clause. */
open class EqualsQueryClause: NSObject, QueryClause {

    private let field: String
    private let value: AnyObject

    private init(_ field: String, _ value: AnyObject) {
        self.field = field
        self.value = value
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
     */
    public convenience init(
      _ field: String,
      intValue: Int)
    {
        self.init(field, intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    */
    public convenience init(
      _ field: String,
      stringValue: String)
    {
        self.init(field, stringValue as AnyObject)
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    */
    public convenience init(
      _ field: String,
      boolValue: Bool)
    {
        self.init(field, boolValue as AnyObject)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "field") as! String,
                  aDecoder.decodeObject(forKey: "value") as AnyObject)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.field, forKey: "field")
        if self.value is Int {
            aCoder.encode(self.value as! Int, forKey: "value")
        } else if self.value is String {
            aCoder.encode(self.value as! String, forKey: "value")
        } else if self.value is Bool {
            aCoder.encode(self.value as! Bool, forKey: "value")
        }
    }

    /** Get EqualsQueryClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }
}

/** Class represents NotEquals clause. */
open class NotEqualsQueryClause: NSObject, QueryClause {
    private let equalClause: EqualsQueryClause

    public init(_ equalClause: EqualsQueryClause) {
        self.equalClause = equalClause
        super.init()
    }

    /** Initialize with String left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter stringValue: Left hand side value to be compared.
    */
    public convenience init(
      _ field: String,
      stringValue: String)
    {
        self.init(EqualsQueryClause(field, stringValue: stringValue))
    }

    /** Initialize with Int left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter intValue: Left hand side value to be compared.
    */
    public convenience init(
      _ field: String,
      intValue: Int)
    {
        self.init(EqualsQueryClause(field, intValue: intValue))
    }

    /** Initialize with Bool left hand side value.

    - Parameter field: Name of the field to be compared.
    - Parameter boolValue: Left hand side value to be compared.
    */
    public convenience init(
      _ field: String,
      boolValue: Bool)
    {
        self.init(EqualsQueryClause(field, boolValue: boolValue))
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! EqualsQueryClause)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.equalClause)
    }

    /** Get NotEqualsQueryClause as [ String : Any ] instance

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
open class RangeQueryClause: NSObject, QueryClause {
    private let field: String
    private let lower: (included: Bool, limit: AnyObject)?
    private let upper: (included: Bool, limit: AnyObject)?

    private init(
      _ field: String,
      lower: (included: Bool, limit: AnyObject)? = nil,
      upper: (included: Bool, limit: AnyObject)? = nil)
    {
        self.field = field
        self.lower = lower
        self.upper = upper
        super.init()
    }

    /** Initialize with Int left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public convenience init(
      _ field:String,
      lowerLimitInt:Int,
      lowerIncluded: Bool)
    {
        self.init(
          field,
          lower: (included: lowerIncluded, limit: lowerLimitInt as AnyObject))
    }

    /** Initialize with Double left hand side value.

    This works as >(greater than) if lower included is false and as
    >=(greater than or equals) if lower included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    */
    public convenience init(
      _ field:String,
      lowerLimitDouble:Double,
      lowerIncluded: Bool)
    {
        self.init(
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

    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitInt: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ field:String,
      upperLimitInt:Int,
      upperIncluded: Bool)
    {
        self.init(
          field,
          upper: (included: upperIncluded, limit: upperLimitInt as AnyObject))
    }

    /** Initialize with Double left hand side value.

    This works as <(less than) if upper included is false and as
    <=(less than or equals) if upper included is true.

    - Parameter field: Name of the field to be compared.
    - Parameter upperLimitDouble: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ field:String,
      upperLimitDouble:Double,
      upperIncluded: Bool)
    {
        self.init(
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

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitInt: Int lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Int upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ field:String,
      lowerLimitInt: Int,
      lowerIncluded: Bool,
      upperLimitInt: Int,
      upperIncluded: Bool)
    {
        self.init(
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

    - Parameter field: Name of the field to be compared.
    - Parameter lowerLimitDouble: Double lower limit value.
    - Parameter lowerIncluded: True provided to include lowerLimit
    - Parameter upperLimit: Double upper limit value.
    - Parameter upperIncluded: True provided to include upperLimit
    */
    public convenience init(
      _ field:String,
      lowerLimitDouble: Double,
      lowerIncluded: Bool,
      upperLimitDouble: Double,
      upperIncluded: Bool)
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
          aDecoder.decodeObject(forKey: "field") as! String,
          lower: lower,
          upper: upper)
    }

    open func encode(with aCoder: NSCoder) {
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

    /** Get RangeQueryClause as [ String : Any ] instance

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
        return retval
    }
}

/** Class represents And clause. */
open class AndQueryClause: NSObject, QueryClause {
    /** clauses array of AndQueryClause */
    open private(set) var clauses = [QueryClause]()

    /** Initialize with clause clauses.

    - Parameter clauses: QueryClause instances for AND clauses
    */
    public convenience init(_ clauses: QueryClause...) {
        self.init(clauses)
    }

    /** Initialize with clause clauses.

     - Parameter clauses: QueryClause array for AND clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
        super.init()
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [QueryClause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to AndQueryClause

    - Parameter clause: QueryClause instances to add
    */
    open func add(_ clause: QueryClause) {
        self.clauses.append(clause)
    }

    /** Get AndQueryClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "and", "clauses": array] as [ String : Any ]
    }
}

/** Class represents Or clause. */
open class OrQueryClause: NSObject, QueryClause {
    /** clauses array of OrQueryClause */
    open private(set) var clauses = [QueryClause]()

    /** Initialize with clause clauses.

     - Parameter clauses: QueryClause array for OR clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
        super.init()
    }

    /** Initialize with clause clauses.

    - Parameter clauses: QueryClause instances for OR clauses
    */
    public convenience init(_ clauses: QueryClause...) {
        self.init(clauses)
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [QueryClause])
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clauses)
    }

    /** Add clause to OrQueryClause

    - Parameter clause: QueryClause instances to add
    */
    open func add(_ clause: QueryClause) {
        self.clauses.append(clause)
    }

    /** Get OrQueryClause as [ String : Any ] instance

    - Returns: a [ String : Any ] instance.
    */
    open func makeDictionary() -> [ String : Any ] {
        var array: [[String : Any]] = []
        self.clauses.forEach { clause in array.append(clause.makeDictionary()) }
        return ["type": "or", "clauses": array] as [ String : Any ]
    }
}

