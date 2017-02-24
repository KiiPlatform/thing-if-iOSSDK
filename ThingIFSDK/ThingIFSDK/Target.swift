//
//  Target.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol representing a target to issue REST API. */
public protocol Target: class, NSObjectProtocol, NSCoding {

    /** ID of target to issue REST API. */
    var typedID: TypedID { get }

    /** Access token. */
    var accessToken: String? { get }

}
