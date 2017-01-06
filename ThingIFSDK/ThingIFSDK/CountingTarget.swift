//
//  CountingTarget.swift
//  ThingIFSDK
//
//  Created on 2017/01/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

open class CountingTarget: NSObject, NSCoding {

    public enum FieldType: String {
        // TODO: we must check what type server can accept.
        case integer = "INTEGER"
        case decimal = "DECIMAL"
        case bool = "BOOL"
        case object = "OBJECT"
        case array = "ARRAY"
    }


    let name: String
    let type: FieldType

    public init(_ name: String, _ type: FieldType) {
        self.name = name
        self.type = type
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "name") as! String,
          FieldType(
            rawValue: aDecoder.decodeObject(forKey: "type") as! String)!)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type.rawValue, forKey: "type")
    }

}
