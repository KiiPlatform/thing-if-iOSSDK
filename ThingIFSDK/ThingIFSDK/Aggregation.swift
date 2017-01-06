//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2016/12/27.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class Aggregation {
    public enum FunctionType {
        case max
        case sum
        case min
        case mean
    }

    public enum FieldType {
        case integer
        case decimal
    }
}
