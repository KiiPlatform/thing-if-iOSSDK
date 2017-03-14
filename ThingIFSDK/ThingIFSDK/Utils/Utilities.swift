//
//  Utilities.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal func +<Key, Value>(
  left: [Key : Value],
  right: [Key : Value]) -> [Key : Value]
{
    var retval = left
    for (key, value) in right {
        retval[key] = value
    }
    return retval
}

internal func +=<Key, Value>(left: inout [Key : Value], right: [Key : Value]) {
    right.forEach { left[$0.0] = $0.1 }
}
