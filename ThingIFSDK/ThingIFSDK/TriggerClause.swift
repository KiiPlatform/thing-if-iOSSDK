//
//  TriggerClause.swift
//  ThingIFSDK
//
//  Created on 2017/01/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Base protocol for trigger clause structs. */
public protocol TriggerClause: BaseClause {

}

/** Struct represents Equals clause for trigger methods. */
public struct EqualsClauseInTrigger: TriggerClause, BaseEquals {

    /** Alias of this clause. */
    public let alias: String
    /** Name of a field. */
    public let field: String
    /** Value of a field. */
    public let value: AnyObject

    private init(_ alias: String, field: String, value: AnyObject) {
        self.alias = alias
        self.field = field
        self.value = value
    }

    /** Initialize with String left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter intValue: Left hand side value to be compared.
     */
    public init(_ alias: String, field: String, intValue: Int) {
        self.init(alias, field: field, value: intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter stringValue: Left hand side value to be compared.
     */
    public init(
      _ alias: String,
      field: String,
      stringValue: String)
    {
        self.init(alias, field: field, value: stringValue as AnyObject)
    }

    /** Initialize with Bool left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter boolValue: Left hand side value to be compared.
     */
    public init(_ alias: String, field: String, boolValue: Bool) {
        self.init(alias, field: field, value: boolValue as AnyObject)
    }
}

extension EqualsClauseInTrigger: JsonObjectSerializable {
    /** Get Equals clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeJson() -> [ String : Any ] {
        return [
          "type" : "eq",
          "alias" : self.alias,
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }

}

/** Struct represents Not Equals clause for trigger methods.  */
public struct NotEqualsClauseInTrigger: TriggerClause, BaseNotEquals {
    public typealias EqualClauseType = EqualsClauseInTrigger

    /** Contained Equals clause instance. */
    public let equals: EqualsClauseInTrigger

    public init(_ equals: EqualsClauseInTrigger) {
        self.equals = equals
    }
}

extension NotEqualsClauseInTrigger: JsonObjectSerializable {
    /** Get Not Equals clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeJson() -> [ String : Any ] {
        return [
          "type" : "not",
          "clause" : self.equals.makeJson()
        ] as [String : Any]
    }

}

/** Struct represents Range clause for trigger methods. */
public struct RangeClauseInTrigger: TriggerClause, BaseRange {

    private let lower: (limit: NSNumber, included: Bool)?
    private let upper: (limit: NSNumber, included: Bool)?

    /** Alias of this clause. */
    public let alias: String
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
      _ alias: String,
      field: String,
      lower: (limit: NSNumber, included: Bool)? = nil,
      upper: (limit: NSNumber, included: Bool)? = nil)
    {
        self.alias = alias
        self.field = field
        self.lower = lower
        self.upper = upper
    }

    /** Create Range clause for trigger having lower and upper limit.

     - Parameter alias: Alias of this clause
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
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    public static func range(
      _ alias: String,
      field: String,
      lowerLimit: NSNumber,
      lowerIncluded: Bool,
      upperLimit: NSNumber,
      upperIncluded: Bool) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          lower: (lowerLimit, lowerIncluded),
          upper: (upperLimit, upperIncluded))
    }

    /** Create Range clause for trigger which denotes greater than.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    public static func greaterThan(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          lower: (limit, false))
    }

    /** Create Range clause for trigger which denotes greater than or
     equals to.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    public static func greaterThanOrEqualTo(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          lower: (limit, true))
    }

    /** Create Range clause for trigger which denotes less than.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    public static func lessThan(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          upper: (limit, false))
    }

    /** Create Range clause for trigger which denotes less than or
     equals to.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    public static func lessThanOrEqualTo(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          upper: (limit, true))
    }
}

extension RangeClauseInTrigger: JsonObjectSerializable {
    /** Get Range clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeJson() -> [ String : Any ] {
        var retval: [String : Any] = [
          "type": "range",
          "alias": alias,
          "field": self.field
        ]
        retval["upperLimit"] = self.upperLimit
        retval["upperIncluded"] = self.upperIncluded
        retval["lowerLimit"] = self.lowerLimit
        retval["lowerIncluded"] = self.lowerIncluded
        return retval
    }

}

/** Struct represents And clause for trigger methods. */
public struct AndClauseInTrigger: TriggerClause, BaseAnd {

    /** Clauses conjuncted with And. */
    public internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for And clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for And clauses
     */
    public init(_ clause: TriggerClause...) {
        self.init(clause)
    }

    /** Add a clause to And clauses.

     - Parameter clause: Clause to be added to and clauses.
     */
    public mutating func add(_ clause: TriggerClause) -> Void {
        self.clauses.append(clause)
    }
}

extension AndClauseInTrigger: JsonObjectSerializable {
    /** Get And clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeJson() -> [ String : Any ] {
        return [
          "type": "and",
          "clauses":
            self.clauses.map {($0 as! JsonObjectSerializable).makeJson()}
        ] as [String : Any]
    }

}

/** Struct represents Or clause for trigger methods. */
public struct OrClauseInTrigger: TriggerClause, BaseOr {

    /** Clauses conjuncted with Or. */
    public internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for Or clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for Or clauses
     */
    public init(_ clause: TriggerClause...) {
        self.init(clause)
    }

    /** Add a clause to Or clauses.

     - Parameter clause: Clause to be added to or clauses.
     */
    public mutating func add(_ clause: TriggerClause) -> Void {
        self.clauses.append(clause)
    }
}

extension OrClauseInTrigger: JsonObjectSerializable {
    /** Get Or clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    internal func makeJson() -> [ String : Any ] {
        return [
          "type": "or",
          "clauses":
            self.clauses.map {($0 as! JsonObjectSerializable).makeJson()}
        ] as [String : Any]
    }

}
