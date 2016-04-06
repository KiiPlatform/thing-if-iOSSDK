//
//  ThingIFArgumentError.swift
//  ThingIFSDK
//
//  Created on 2016/04/06.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation
import Swift

/**
Argument errors for Thing-IF.
*/
public enum ThingIFArgumentError: ErrorType {

    /**
    If a argument of a method is invalid, this error is thrown.
    */
    case InvalidArgument(message: String)

}
