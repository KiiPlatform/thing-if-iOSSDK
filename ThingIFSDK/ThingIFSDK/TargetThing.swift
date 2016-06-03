//
//  TargetThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public protocol TargetThing: Target {
    var thingID: String { get }
    var vendorThingID: String { get }
}
