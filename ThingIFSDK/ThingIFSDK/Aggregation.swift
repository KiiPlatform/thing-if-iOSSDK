//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2016/12/27.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
 A class to specify aggregation.

 This class contains data in order to aggregate with
 `ThingIFAPI.aggregate(_:_:_:clause:firmwareVersion:completionHandler:)`.
 */
open class Aggregation: NSObject, NSCoding {

    // MARK: - Enumerations

    /** Function used aggregation. */
    public enum Function: String {

        /** A function to calculate max of a field of queried objects. */
        case max

        /** A function to calculate sum of a field of queried objects. */
        case sum

        /** A function to calculate min of a field of queried objects. */
        case min

        /** A function to calculate mean of a field of queried objects. */
        case mean
    }

    /** A field type to aggregate. */
    public enum FieldType: String {

        /** A enumeration element to denote integer type. */
        case integer = "INTEGER"

        /** A enumeration element to denote decimal type. */
        case decimal = "DECIMAL"
    }

    // MARK: - Properties

    /** a field name to be aggregated. */
    open let name: String

    /** a field type to be aggregated. */
    open let type: FieldType

    /** a function applied to aggregated fields. */
    open let function: Function

    // MARK: - Initializing TriggeredCommandForm instance.
    /** Initializer of `Aggregation` instance.

     - Parameter name: a field name to be aggregated.
     - Parameter type: a field type to be aggregated.
     - Parameter function: a function applied to aggregated fields.
     */
    public init(_ name: String, _ type: FieldType, _ function: Function) {
        self.name = name
        self.type = type
        self.function = function
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "name") as! String,
          FieldType(
            rawValue: aDecoder.decodeObject(forKey: "type") as! String)!,
          Function(
            rawValue: aDecoder.decodeObject(forKey: "function") as!String)!)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.function.rawValue, forKey: "function")
    }

}
