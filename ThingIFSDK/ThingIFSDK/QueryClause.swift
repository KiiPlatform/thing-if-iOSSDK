//
//  QueryClause.swift
//  ThingIFSDK
//
//  Created on 2017/01/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Base protocol for query clause struct. */
public protocol QueryClause: BaseClause {

}

/** Struct represents Equals clause for query methods. */
public struct EqualsClauseInQuery: QueryClause, BaseEquals {

    /** Name of a field. */
    public let field: String
    /** Value of a field. */
    public let value: AnyObject

    private init(_ field: String, value: AnyObject) {
        self.field = field
        self.value = value
    }

    /** Initialize with String left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter intValue: Left hand side value to be compared.
     */
    public init(_ field: String, intValue: Int) {
        self.init(field, value: intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter stringValue: Left hand side value to be compared.
     */
    public init(_ field: String, stringValue: String) {
        self.init(field, value: stringValue as AnyObject)
    }

    /** Initialize with Bool left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter boolValue: Left hand side value to be compared.
     */
    public init(_ field: String, boolValue: Bool) {
        self.init(field, value: boolValue as AnyObject)
    }
}

extension EqualsClauseInQuery: Dictionarable {
    /** Get Equals clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeDictionary() -> [ String : Any ] {
        return [
          "type" : "eq",
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }

}

/** Struct represents Not Equals clause for query methods.  */
public struct NotEqualsClauseInQuery: QueryClause, BaseNotEquals {
    public typealias EqualClauseType = EqualsClauseInQuery

    /** Contained Equals clause instance. */
    public let equals: EqualsClauseInQuery

    /** Initialize with `EqualsClauseInQuery`.

     - Parameter equals: equals clause.
     */
    public init(_ equals: EqualsClauseInQuery) {
        self.equals = equals
    }
}

extension NotEqualsClauseInQuery: Dictionarable {
    /** Get Not Equals clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeDictionary() -> [ String : Any ] {
        return [
          "type" : "not",
          "clause" : self.equals.makeDictionary()
        ] as [String : Any]
    }

}

/** Struct represents Range clause for query methods. */
public struct RangeClauseInQuery: QueryClause, BaseRange {

    private let lower: (limit: NSNumber, included: Bool)?
    private let upper: (limit: NSNumber, included: Bool)?

    /** Name of a field. */
    public let field: String

    /** Lower limit for an instance. */
    public var lowerLimit: NSNumber? {
        get {
            return self.lower?.limit
        }
    }

    /** Include or not lower limit. */
    public var lowerIncluded: Bool? {
        get {
            return self.lower?.included
        }
    }

    /** Upper limit for an instance. */
    public var upperLimit: NSNumber? {
        get {
            return self.upper?.limit
        }
    }

    /** Include or not upper limit. */
    public var upperIncluded: Bool? {
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
    public static func range(
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
    public static func greaterThan(
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
    public static func greaterThanOrEqualTo(
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
    public static func lessThan(
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
    public static func lessThanOrEqualTo(
      _ field: String,
      limit: NSNumber) -> RangeClauseInQuery
    {
        return RangeClauseInQuery(field, upper: (limit, true))
    }
}

extension RangeClauseInQuery: Dictionarable {
    /** Get Range clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeDictionary() -> [ String : Any ] {
        var retval: [String : Any] = ["type": "range", "field": self.field]
        retval["upperLimit"] = self.upperLimit
        retval["upperIncluded"] = self.upperIncluded
        retval["lowerLimit"] = self.lowerLimit
        retval["lowerIncluded"] = self.lowerIncluded
        return retval
    }
}


/** Struct represents And clause for query methods. */
public struct AndClauseInQuery: QueryClause, BaseAnd {

    /** Clauses conjuncted with And. */
    public internal(set) var clauses: [QueryClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for And clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for And clauses
     */
    public init(_ clause: QueryClause...) {
        self.init(clause)
    }

    /** Add a clause to And clauses.

     - Parameter clause: Clause to be added to and clauses.
     */
    public mutating func add(_ clause: QueryClause) -> Void {
        self.clauses.append(clause)
    }
}

extension AndClauseInQuery: Dictionarable {
    /** Get And clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeDictionary() -> [ String : Any ] {
        return [
          "type": "and",
          "clauses":
            self.clauses.map {($0 as! Dictionarable).makeDictionary()}
        ] as [String : Any]
    }

}

/** Struct represents Or clause for query methods. */
public struct OrClauseInQuery: QueryClause, BaseOr {

    /** Clauses conjuncted with Or. */
    public internal(set) var clauses: [QueryClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for Or clauses
     */
    public init(_ clauses: [QueryClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for Or clauses
     */
    public init(_ clause: QueryClause...) {
        self.init(clause)
    }

    /** Add a clause to Or clauses.

     - Parameter clause: Clause to be added to or clauses.
     */
    public mutating func add(_ clause: QueryClause) -> Void {
        self.clauses.append(clause)
    }
}

extension OrClauseInQuery: Dictionarable {
    /** Get Or clause for query as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeDictionary() -> [ String : Any ] {
        return [
          "type": "or",
          "clauses":
            self.clauses.map {($0 as! Dictionarable).makeDictionary()}
        ] as [String : Any]
    }

}

/** Struct represents All clause for query methods.

 If you want to get all history state, you can use this clause.
 */
public struct AllClause: QueryClause {

}

extension AllClause: Dictionarable {

    internal func makeDictionary() -> [String : Any]{
        return ["type": "all"]
    }
}
