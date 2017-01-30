//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregation. */
open class Aggregation: NSCoding {

    /** Field types to count. */
    public enum FieldType: String {

        /** A type of a int field. */
        case integer = "INTEGER"

        /** A type of a decimal field. */
        case decimal = "DECIMAL"

        /** A type of a boolean field. */
        case bool = "BOOL"

        /** A type of a object field. */
        case object = "OBJECT"

        /** A type of a array field. */
        case array = "ARRAY"
    }

    /** Functions used aggregation. */
    public enum FunctionType: String {

        /** A function to calculate max of a field of queried objects. */
        case max

        /** A function to calculate sum of a field of queried objects. */
        case sum

        /** A function to calculate min of a field of queried objects. */
        case min

        /** A function to calculate mean of a field of queried objects. */
        case mean

        /** A function to count queried objects. */
        case count

    }

    /** Name of a target field. */
    let field: String
    /** Field type. */
    let fieldType: FieldType
    /** Function type. */
    let function: FunctionType


    public init(_ field: String, fieldType: FieldType, function: FunctionType) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
