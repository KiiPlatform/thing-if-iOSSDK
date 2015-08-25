//
//  NSNumber+isBool.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension NSNumber {
    public func isBool() -> Bool {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }

    public func isDouble() -> Bool{
        let numberType = CFNumberGetType(self)
        if numberType == CFNumberType.Float64Type {
            return true
        }else {
            return false
        }
    }

    public func isInt() -> Bool{
        let numberType = CFNumberGetType(self)
        if numberType == CFNumberType.SInt64Type ||
            numberType == CFNumberType.SInt16Type ||
            numberType == CFNumberType.SInt32Type {
            return true
        }else {
            return false
        }
    }
}