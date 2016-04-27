//
//  TargetThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public protocol TargetThing: Target {
    func getThingID() -> String
    func getVendorThingID() -> String
}