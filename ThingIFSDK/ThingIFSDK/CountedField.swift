//
//  CountedField.swift
//  ThingIFSDK
//
//  Created on 2017/01/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/**
 A class to specify counted field.

 This class contains data in order to count with
`ThingIFAPI.count(_:_:_:clause:firmwareVersion:completionHandler:)`.
 */
open class CountedField: NSObject, NSCoding {

    // MARK: - Enumerations

    /** Field types to count. */
    public enum FieldType: String {
        // TODO: we must check what type server can accept.
        case integer = "INTEGER"
        case decimal = "DECIMAL"
        case bool = "BOOL"
        case object = "OBJECT"
        case array = "ARRAY"
    }

    /** Name of a field to be counted. */
    let name: String

    /** Type of a field to be counted. */
    let type: FieldType

    // MARK: - Initializing TriggeredCommandForm instance.
    /** Initializer of `CountedField` instance.

     - Parameter name: Name of a field to be aggregated.
     - Parameter type: Type of a field to be aggregated.
     */
    public init(_ name: String, type: FieldType) {
        self.name = name
        self.type = type
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "name") as! String,
          type: FieldType(
            rawValue: aDecoder.decodeObject(forKey: "type") as! String)!)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type.rawValue, forKey: "type")
    }

}