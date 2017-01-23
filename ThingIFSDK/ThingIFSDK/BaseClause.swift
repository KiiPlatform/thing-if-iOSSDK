//
//  BaseClause.swift
//  ThingIFSDK
//
//  Created 信介 on 2017/01/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Protocol for any clauses class. */
public protocol BaseClause: NSCoding {

    /** Get Clause as Dictionary instance

    - Returns: a Dictionary instance.
    */
    func makeDictionary() -> [ String : Any ]

}

/** Protocol for equals clause class */
public protocol BaseEquals: BaseClause {

    /** Name of a field. */
    var field: String { get }
    /** Value of a field. */
    var value: Any { get }
}

/** Protocol for not equals clause class */
public protocol BaseNotEquals: BaseClause {

    /** Type of a contained instance */
    associatedtype EqualClauseType: BaseEquals

    /** Contained equals clause object. */
    var equals: EqualClauseType { get }
}

/** Protocol for range clause. */
public protocol BaseRange: BaseClause {

    /** Name of a field. */
    var field: String { get }
    /** lower limit for an instance. */
    var lower: (limit: AnyObject, included: Bool)? { get }
    /** upper limit for an instance. */
    var upper: (limit: AnyObject, included: Bool)? { get }
}

/** Protocol for and clause. */
public protocol BaseAnd: BaseClause {

    /** Type of contained instances */
    associatedtype ClausesType: BaseClause

    /** Contained clauses. */
    var clauses: [ClausesType] { get }

    /** Add a clause. */
    func add(_ clause: ClausesType) -> Void
}


/** Protocol for or clause. */
public protocol BaseOr: BaseClause {

    /** Type of contained instances */
    associatedtype ClausesType: BaseClause

    /** Contained clauses. */
    var clauses: [ClausesType] { get }

    /** Add a clause. */
    func add(_ clause: ClausesType) -> Void
}
