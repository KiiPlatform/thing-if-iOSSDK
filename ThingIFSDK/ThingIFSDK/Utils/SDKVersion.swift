//
//  SDKVersion.swift
//  ThingIFSDK
//
//  Copyright © 2016年 Kii. All rights reserved.
//
import UIKit

/** Accessor of the Thing-IF SDK version. */
public class SDKVersion: NSObject {
    /** Obtain singleton instance */
    public class var sheredInstance : SDKVersion {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SDKVersion? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SDKVersion()
        }
        return Static.instance!
    }
    /** Version of the Thing-IF SDK */
    public var versionString:String?
    internal var kiiSDKHeader:String?
    override init() {
        let b:NSBundle? = NSBundle.allFrameworks().filter{$0.bundleIdentifier == "Kii-Corporation.ThingIFSDK"}.first
        versionString = b?.infoDictionary?["CFBundleShortVersionString"] as! String?
        if let v = versionString {
            kiiSDKHeader = "sn=it;sv=\(v);pv=\(UIDevice.currentDevice().systemVersion)"
        }
    }
}
