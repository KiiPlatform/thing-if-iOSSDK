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
open class EqualsClauseInTrigger: TriggerClause, BaseEquals {

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
        return [
          "type" : "eq",
          "alias" : self.alias,
          "field" : self.field,
          "value" : self.value
        ] as [String : Any]
    }

    fileprivate convenience init?(_ dict: [String : Any]) {
        if dict["type"] as? String != "eq" {
            return nil
        }
        self.init(
          dict["alias"] as! String,
          field: dict["field"] as! String,
          value: dict["value"] as AnyObject)
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! [String : Any])
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.makeDictionary())
    }

}

/** Class represents Not Equals clause for trigger methods.  */
open class NotEqualsClauseInTrigger: TriggerClause, BaseNotEquals {
    public typealias EqualClauseType = EqualsClauseInTrigger

    /** Contained Equals clause instance. */
    open let equals: EqualsClauseInTrigger

    public init(_ equals: EqualsClauseInTrigger) {
        self.equals = equals
    }

    /** Get Not Equals clause for trigger as a Dictionary instance

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
        guard let dict = aDecoder.decodeObject() as? [String : Any] else {
            return nil
        }
        self.init(dict)
    }

    fileprivate convenience init?(_ dict: [String : Any]) {
        if dict["type"] as? String != "not" {
            return nil
        }

        if let equals = EqualsClauseInTrigger(
             dict["clause"] as! [String : Any])
        {
            self.init(equals)
        } else {
            return nil
        }
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.makeDictionary())
    }

}

/** Class represents Range clause for trigger methods. */
open class RangeClauseInTrigger: TriggerClause, BaseRange {

    private let lower: (limit: NSNumber, included: Bool)?
    private let upper: (limit: NSNumber, included: Bool)?

    /** Alias of this clause. */
    open let alias: String
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
    open static func range(
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
    open static func greaterThan(
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
    open static func greaterThanOrEqualTo(
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
    open static func lessThan(
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
    open static func lessThanOrEqualTo(
      _ alias: String,
       field: String,
      limit: NSNumber) -> RangeClauseInTrigger
    {
        return RangeClauseInTrigger(
          alias,
          field: field,
          upper: (limit, true))
    }

    /** Get Range clause for trigger as a Dictionary instance

     - Returns: A Dictionary instance.
     */
    open func makeDictionary() -> [ String : Any ] {
        var retval: [String : Any] = [
          "type": "range",
          "alias": alias,
          "field": self.field
        ]
        retval["upperLimit"] = self.upper?.limit
        retval["upperIncluded"] = self.upper?.included
        retval["lowerLimit"] = self.lower?.limit
        retval["lowerIncluded"] = self.lower?.included
        return retval
    }

    /** Decoder confirming `NSCoding`. */
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let dict = aDecoder.decodeObject() as? [String : Any] else {
            return nil
        }
        self.init(dict)
    }

    fileprivate convenience init?(_ dict: [String : Any]) {
        if dict["type"] as? String != "range" {
            return nil
        }
        self.init(
          dict["alias"] as! String,
          field: dict["field"] as! String,
          lower: makeLimitTuple(
            dict["lowerLimit"] as? NSNumber,
            included: dict["lowerIncluded"] as? Bool),
          upper: makeLimitTuple(
            dict["upperLimit"] as? NSNumber,
            included: dict["upperIncluded"] as? Bool))
    }

    /** Encoder confirming `NSCoding`. */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.makeDictionary())
    }

}


/** Class represents And clause for trigger methods. */
open class AndClauseInTrigger: TriggerClause, BaseAnd {
    public typealias ClausesType = TriggerClause

    /** Clauses conjuncted with And. */
    open internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for And clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
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
open class OrClauseInTrigger: TriggerClause, BaseOr {
    public typealias ClausesType = TriggerClause

    /** Clauses conjuncted with Or. */
    open internal(set) var clauses: [TriggerClause]

    /** Initialize with clauses array.

     - Parameter clauses: Clause instances for Or clauses
     */
    public init(_ clauses: [TriggerClause]) {
        self.clauses = clauses
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
