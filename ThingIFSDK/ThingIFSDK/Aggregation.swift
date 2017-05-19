//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregation. */
public struct Aggregation {

    /** Field types to count. */
    public enum FieldType: String {

        /** A type of a int field. */
        case integer = "INTEGER"

        /** A type of a decimal field. */
        case decimal = "DECIMAL"

        /** A type of a boolean field. */
        case bool = "BOOLEAN"

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
    public let field: String
    /** Field type. */
    public let fieldType: FieldType
    /** Function type. */
    public let function: FunctionType


    private init(
      _ function: FunctionType,
      field: String,
      fieldType: FieldType)
    {
        self.function = function
        self.field = field
        self.fieldType = fieldType
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
        if function == .max || function == .sum || function == .min ||
             function == .mean {
            if fieldType != .integer && fieldType != .decimal {
                throw ThingIFError.invalidArgument(
                  message: function.rawValue + " can not use " +
                    fieldType.rawValue)
            }
        }

        return Aggregation(function, field: field, fieldType: fieldType)
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
        return try! makeAggregation(.count, field: field, fieldType: fieldType)
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
        return try makeAggregation(.mean, field: field, fieldType: fieldType)
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
        return try makeAggregation(.max, field: field, fieldType: fieldType)
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
        return try makeAggregation(.min, field: field, fieldType: fieldType)
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
        return try makeAggregation(.sum, field: field, fieldType: fieldType)
    }

}

extension Aggregation : ToJsonObject {
    internal func makeJsonObject() -> [String : Any]{
        return [
            "type": self.function.rawValue.uppercased(),
            "putAggregationInto": self.function.rawValue.lowercased(),
            "field": self.field,
            "fieldType": self.fieldType.rawValue
        ]
    }
}
