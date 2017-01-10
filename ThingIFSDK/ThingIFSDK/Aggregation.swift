//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2016/12/27.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class Aggregation: NSObject, NSCoding {

    public enum Function: String {
        case max
        case sum
        case min
        case mean
    }

    public enum FieldType: String {
        case integer = "INTEGER"
        case decimal = "DECIMAL"
    }

    open let name: String
    open let function: Function
    open let type: FieldType

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
