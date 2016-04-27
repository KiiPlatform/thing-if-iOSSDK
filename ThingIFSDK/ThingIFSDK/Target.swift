//
//  Target.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public protocol Target: NSCoding {
    func getTypedID() -> TypedID
    func getAccessToken() -> String?
}
