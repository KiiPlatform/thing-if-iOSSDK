//
//  NSNumber+isBool.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

internal extension NSNumber {
    internal func isBool() -> Bool {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }

    internal func isDouble() -> Bool{
        let numberType = CFNumberGetType(self)
        if numberType == CFNumberType.float64Type {
            return true
        }else {
            return false
        }
    }

    internal func isInt() -> Bool{
        let numberType = CFNumberGetType(self)
        if numberType == CFNumberType.sInt64Type ||
            numberType == CFNumberType.sInt16Type ||
            numberType == CFNumberType.sInt32Type {
            return true
        }else {
            return false
        }
    }
}
