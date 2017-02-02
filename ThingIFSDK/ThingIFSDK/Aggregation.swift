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


    private init(
      _ function: FunctionType,
      field: String,
      fieldType: FieldType)
    {
        fatalError("TODO: implement me.")
    }

    /** Make aggregation.

     - Parameter function: Type of aggregation function.
     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation`.
     - Throws: 'ThingIFError.invalidArgument` if function and
       fieldType matches following cases:
       - Function type is `Aggregation.FunctionType.max` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.min` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.sum` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.mean` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
     */
    public static func makeAggregation(
      _ function: FunctionType,
      field: String,
      fieldType: FieldType) throws -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    /** Make aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for count function.
     */
    public static func makeCountAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    /** Make mean aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for mean.
     - Throws: 'ThingIFError.invalidArgument.` If field type not is
       `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMeanAggregation(
      _ field: String,
      fieldType: FieldType) throws -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    /** Make max aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for max.
     - Throws: 'ThingIFError.invalidArgument.` If field type not is
       `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMaxAggregation(
      _ field: String,
      fieldType: FieldType) throws -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    /** Make min aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for min.
     - Throws: 'ThingIFError.invalidArgument.` If field type not is
       `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMinAggregation(
      _ field: String,
      fieldType: FieldType) throws -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    /** Make sum aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for sum.
     - Throws: 'ThingIFError.invalidArgument.` If field type not is
       `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeSumAggregation(
      _ field: String,
      fieldType: FieldType) throws -> Aggregation
    {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
