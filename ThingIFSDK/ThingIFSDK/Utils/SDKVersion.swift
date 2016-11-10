//
//  SDKVersion.swift
//  ThingIFSDK
//
//  Copyright © 2016年 Kii. All rights reserved.
//
import UIKit

/** Accessor of the Thing-IF SDK version. */
open class SDKVersion: NSObject {
    open static let sharedInstance = SDKVersion()
    /** Version of the Thing-IF SDK */
    open let versionString:String
    internal var kiiSDKHeader:String
    private override init() {
        let b:Bundle? = Bundle.allFrameworks.filter{$0.bundleIdentifier == "Kii-Corporation.ThingIFSDK"}.first
        if let v = b?.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionString = v
        } else {
            versionString = "0.0.0"
        }
        kiiSDKHeader = "sn=it;sv=\(versionString);pv=\(UIDevice.current.systemVersion)"
    }
}
