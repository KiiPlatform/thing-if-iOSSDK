//
//  Function.swift
//  ThingIFSDK
//
//  Created on 2017/01/11.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Functions used aggregation. */
public enum Function: String {

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

