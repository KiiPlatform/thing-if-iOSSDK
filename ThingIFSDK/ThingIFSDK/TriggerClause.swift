//
//  TriggerClause.swift
//  ThingIFSDK
//
//  Created on 2017/01/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Base protocol for trigger clause classes. */
public protocol TriggerClause: BaseClause {

}

/** Class represents Equals clause for trigger methods. */
open class EqualsClauseInTrigger: NSObject, TriggerClause, BaseEquals {

    /** Alias of this clause. */
    open let alias: String
    /** Name of a field. */
    open let field: String
    /** Value of a field. */
    open let value: AnyObject

    private init(_ alias: String, field: String, value: AnyObject) {
        self.alias = alias
        self.field = field
        self.value = value
        super.init()
    }

    /** Initialize with String left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter intValue: Left hand side value to be compared.
     */
    public convenience init(_ alias: String, field: String, intValue: Int) {
        self.init(alias, field: field, value: intValue as AnyObject)
    }

    /** Initialize with Int left hand side value.

     - Parameter field: Name of the field to be compared.
     - Parameter stringValue: Left hand side value to be compared.
     */
    public convenience init(
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
    public convenience init(_ alias: String, field: String, boolValue: Bool) {
        self.init(alias, field: field, value: boolValue as AnyObject)
    }

    /** Get Equals clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}

/** Class represents Not Equals clause for trigger methods.  */
open class NotEqualsClauseInTrigger: NSObject, TriggerClause, BaseNotEquals {
    public typealias EqualClauseType = EqualsClauseInTrigger

    /** Contained Equals clause instance. */
    open let equals: EqualsClauseInTrigger

    public init(_ equals: EqualsClauseInTrigger) {
        self.equals = equals
        super.init()
    }

    /** Get Not Equals clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}

/** Class represents Range clause for trigger methods. */
open class RangeClauseInTrigger: NSObject, TriggerClause, BaseRange {

    /** Alias of this clause. */
    open let alias: String
    /** Name of a field. */
    open let field: String
    /** lower limit for an instance. */
    open let lower: (limit: NSNumber, included: Bool)?
    /** upper limit for an instance. */
    open let upper: (limit: NSNumber, included: Bool)?

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
        super.init()
    }

    /** Create Range clause for trigger having lower and upper limit.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter lower: lower limit
       - limit: Limit value. The type must be integer, double or
         float.
       - included: Includes limit value or not. If true, limit value
         is included. If false, limit value is not included
     - Parameter upper: upper limit
       - limit: Limit value. The type must be integer, double or
         float.
       - included: Includes limit value or not. If true, limit value
         is included. If false, limit value is not included
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    open static func range(
      _ alias: String,
       field: String,
      lower: (limit: NSNumber, included: Bool),
      upper: (limit: NSNumber, included: Bool)) -> RangeClauseInTrigger
    {
        fatalError("TODO: implement me.")
    }

    /** Create Range clause for trigger which denotes greater than.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    open static func greaterThan(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        fatalError("TODO: implement me.")
    }

    /** Create Range clause for trigger which denotes greater than or
     equals to.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    open static func greaterThanOrEqualTo(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        fatalError("TODO: implement me.")
    }

    /** Create Range clause for trigger which denotes less than.

     - Parameter alias: Alias of this clause
     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    open static func lessThan(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        fatalError("TODO: implement me.")
    }

    /** Create Range clause for trigger which denotes less than or
     equals to.

     - Parameter field: Name of the field to be compared.
     - Parameter limit: Limit value. The type must be integer, double
       or float.
     - Returns: An instance of `RangeClauseInTrigger`.
     */
    open static func lessThanOrEqualTo(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        fatalError("TODO: implement me.")
    }

    /** Get Range clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}


/** Class represents And clause for trigger methods. */
open class AndClauseInTrigger: NSObject, TriggerClause, BaseAnd {
    public typealias ClausesType = TriggerClause

    /** Clauses conjuncted with And. */
    open internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for And clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
        super.init()
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for And clauses
     */
    public convenience init(_ clause: TriggerClause...) {
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
    open func add(_ clause: TriggerClause) -> Self {
        fatalError("TODO: implement me.")
    }

    /** Get And clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

}

/** Class represents Or clause for trigger methods. */
open class OrClauseInTrigger: NSObject, TriggerClause, BaseOr {
    public typealias ClausesType = TriggerClause

    /** Clauses conjuncted with Or. */
    open internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for Or clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
        super.init()
    }

    /** Initialize with clauses.

     - Parameter clauses: Clause array for Or clauses
     */
    public convenience init(_ clause: TriggerClause...) {
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
    open func add(_ clause: TriggerClause) -> Self {
        fatalError("TODO: implement me.")
    }

    /** Get Or clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        fatalError("TODO: implement me.")
    }

}
