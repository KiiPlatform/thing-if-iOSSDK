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
    open let versionString:String?
    internal var kiiSDKHeader:String?
    fileprivate override init() {
        let b:Bundle? = Bundle.allFrameworks.filter{$0.bundleIdentifier == "Kii-Corporation.ThingIFSDK"}.first
        versionString = b?.infoDictionary?["CFBundleShortVersionString"] as! String?
        if let v = versionString {
            kiiSDKHeader = "sn=it;sv=\(v);pv=\(UIDevice.current.systemVersion)"
        }
    }
}
