//
//  BaseClause.swift
//  ThingIFSDK
//
//  Created on 2017/01/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Base protocol for all clause classes. */
public protocol BaseClause: class, NSCoding {

    /** Get Clause as Dictionary instance

     - Returns: a Dictionary instance.
     */
    func makeDictionary() -> [ String : Any ]

}

/** Protocol for Equals clause classes */
public protocol BaseEquals: BaseClause {

    /** Name of a field. */
    var field: String { get }
    /** Value of a field. */
    var value: AnyObject { get }
}

/** Protocol for Not Equals clause classes */
public protocol BaseNotEquals: BaseClause {

    /** Type of a contained instance */
    associatedtype EqualClauseType: BaseEquals

    /** Contained Equals clause instance. */
    var equals: EqualClauseType { get }
}

/** Protocol for Range clause classes. */
public protocol BaseRange: BaseClause {

    /** Name of a field. */
    var field: String { get }
    /** lower limit for an instance. */
    var lower: (limit: NSNumber, included: Bool)? { get }
    /** upper limit for an instance. */
    var upper: (limit: NSNumber, included: Bool)? { get }
}

/** Protocol for And clause classes. */
public protocol BaseAnd: BaseClause {

    /** Type of contained instances */
    associatedtype ClausesType: BaseClause

    /** Contained clauses. */
    var clauses: [ClausesType] { get }

    /** Add a clause. */
    func add(_ clause: ClausesType) -> Self
}


/** Protocol for Or clause classes. */
public protocol BaseOr: BaseClause {

    /** Type of contained instances */
    associatedtype ClausesType: BaseClause

    /** Contained clauses. */
    var clauses: [ClausesType] { get }

    /** Add a clause. */
    func add(_ clause: ClausesType) -> Self
}
