//
//  QueryClause.swift
//  ThingIFSDK
//
//  Created on 2017/01/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Base protocol for query clause classes. */
public protocol QueryClause: BaseClause {

}

/** Class represents Equals clause for query methods. */
open class EqualsClauseInQuery: QueryClause, BaseEquals {

    /** Name of a field. */
    open let field: String
    /** Value of a field. */
    open let value: AnyObject

    private init(_ field: String, value: AnyObject) {
        self.field = field
        self.value = value
    }

    /** Initialize with String left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter intValue: Left hand side value to be compared.
     */
    public convenience init(_ field: String, intValue: Int) {
        self.init(field, value: intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter stringValue: Left hand side value to be compared.
     */
    public convenience init(_ field: String, stringValue: String) {
        self.init(field, value: stringValue as AnyObject)
    }

    /** Initialize with Bool left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter boolValue: Left hand side value to be compared.
     */
    public convenience init(_ field: String, boolValue: Bool) {
        self.init(field, value: boolValue as AnyObject)
    }

    /** Get Equals clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }

    fileprivate convenience init(_ dict: [String : Any]) {
        self.init(dict["field"] as! String, value: dict["value"] as AnyObject)
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [String : Any])
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        aCoder.encodeRootObject(self.makeDictionary())
    }

}

/** Class represents Not Equals clause for query methods.  */
open class NotEqualsClauseInQuery: QueryClause, BaseNotEquals {
    public typealias EqualClauseType = EqualsClauseInQuery

    /** Contained Equals clause instance. */
    open let equals: EqualsClauseInQuery

    public init(_ equals: EqualsClauseInQuery) {
        self.equals = equals
    }

    /** Get Not Equals clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        return [
          "type" : "not",
          "clause" : self.equals.makeDictionary()
        ] as [String : Any]
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          EqualsClauseInQuery(aDecoder.decodeObject() as! [String : Any]))
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        self.equals.encode(with: aCoder)
    }

}

/** Class represents Range clause for query methods. */
open class RangeClauseInQuery: QueryClause, BaseRange {

    private let lower: (limit: NSNumber, included: Bool)?
    private let upper: (limit: NSNumber, included: Bool)?

    /** Name of a field. */
    open let field: String

    /** Lower limit for an instance. */
    open var lowerLimit: NSNumber? {
        get {
            return self.lower?.limit
        }
    }

    /** Include or not lower limit. */
    open var lowerIncluded: Bool? {
        get {
            return self.lower?.included
        }
    }

    /** Upper limit for an instance. */
    open var upperLimit: NSNumber? {
        get {
            return self.upper?.limit
        }
    }

    /** Include or not upper limit. */
    open var upperIncluded: Bool? {
        get {
            return self.upper?.included
        }
    }

    private init(
      _ field: String,
      lower: (limit: NSNumber, included: Bool)? = nil,
      upper: (limit: NSNumber, included: Bool)? = nil)
    {
        self.field = field
        self.lower = lower
        self.upper = upper
    }

    /** Create Range clause for query having lower and upper limit.

     - Parameter field: Name of the field to be compared.
     - Parameter lowerLimit: Lower limit value. The type must be
       integer, double or float.
     - Parameter lowerIncluded: Includes lower limit value or not. If
       true, limit value is included. If false, limit value is not
       included
     - Parameter upperLimit: Upper limit value. The type must be
       integer, double or float.
     - Parameter upperIncluded: Includes upper limit value or not. If
       true, limit value is included. If false, limit value is not
       included
     - Returns: An instance of `RangeClauseInQuery`.
     */
    open static func range(
      _ field: String,
      lowerLimit: NSNumber,
      lowerIncluded: Bool,
      upperLimit: NSNumber,
      upperIncluded: Bool) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(
          field,
          lower: (lowerLimit, lowerIncluded),
          upper: (upperLimit, upperIncluded))
    }

    /** Create Range clause for query which denotes greater than.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInQuery`.
     */
    open static func greaterThan(
      _ field: String,
      limit: NSNumber) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(field, lower: (limit, false))
    }

    /** Create Range clause for query which denotes greater than or
     equals to.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInQuery`.
     */
    open static func greaterThanOrEqualTo(
      _ field: String,
      limit: NSNumber) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(field, lower: (limit, true))
    }

    /** Create Range clause for query which denotes less than.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInQuery`.
     */
    open static func lessThan(
      _ field: String,
      limit: NSNumber) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(field, upper: (limit, false))
    }

    /** Create Range clause for query which denotes less than or
     equals to.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInQuery`.
     */
    open static func lessThanOrEqualTo(
      _ field: String,
      limit: NSNumber) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(field, upper: (limit, true))
    }

    /** Get Range clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        var retval: [String : Any] = ["type": "range", "field": self.field]
        retval["upperLimit"] = self.upper?.limit
        retval["upperIncluded"] = self.upper?.included
        retval["lowerLimit"] = self.lower?.limit
        retval["lowerIncluded"] = self.lower?.included
        return retval
    }

    private static func toRangeTuple(
      _ dictOpt: [String : Any]?) -> (limit: NSNumber, included: Bool)?
    {
        if let dict = dictOpt {
            return (dict["limit"] as! NSNumber, dict["included"] as! Bool)
        }
        return nil
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "field") as! String,
          lower: RangeClauseInQuery.toRangeTuple(
            aDecoder.decodeObject(forKey: "lower") as? [String : Any]),
          upper: RangeClauseInQuery.toRangeTuple(
            aDecoder.decodeObject(forKey: "upper") as? [String : Any]))
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.field, forKey: "field")
        if let lower = self.lower {
            let dict: [String : Any] =
              ["limit": lower.limit, "included": lower.included]
            aCoder.encode(dict, forKey: "lower")
        }
        if let upper = self.upper {
            let dict: [String : Any] =
              ["limit": upper.limit, "included": upper.included]
            aCoder.encode(dict, forKey: "upper")
        }
    }

}


/** Class represents And clause for query methods. */
open class AndClauseInQuery: QueryClause, BaseAnd {
    public typealias ClausesType = QueryClause

    /** Clauses conjuncted with And. */
    open internal(set) var clauses: [QueryClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for And clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for And clauses
     */
    public convenience init(_ clause: QueryClause...) {
        self.init(clause)
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Add a clause to And clauses.

     - Parameter clause: Clause to be added to and clauses.
     */
    open func add(_ clause: QueryClause) -> Self {
        fatalError("TODO: implement me.")
    }

    /** Get And clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

}

/** Class represents Or clause for query methods. */
open class OrClauseInQuery: QueryClause, BaseOr {
    public typealias ClausesType = QueryClause

    /** Clauses conjuncted with Or. */
    open internal(set) var clauses: [QueryClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for Or clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for Or clauses
     */
    public convenience init(_ clause: QueryClause...) {
        self.init(clause)
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Add a clause to Or clauses.

     - Parameter clause: Clause to be added to or clauses.
     */
    open func add(_ clause: QueryClause) -> Self {
        fatalError("TODO: implement me.")
    }

    /** Get Or clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

}
