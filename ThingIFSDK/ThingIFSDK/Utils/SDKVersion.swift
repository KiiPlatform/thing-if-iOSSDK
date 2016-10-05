//
//  SDKVersion.swift
//  ThingIFSDK
//
//  Copyright © 2016年 Kii. All rights reserved.
//
import UIKit

/** Accessor of the Thing-IF SDK version. */
public class SDKVersion: NSObject {
    public static let sharedInstance = SDKVersion()
    /** Version of the Thing-IF SDK */
    public let versionString:String?
    internal var kiiSDKHeader:String?
    private override init() {
        let b:NSBundle? = NSBundle.allFrameworks().filter{$0.bundleIdentifier == "Kii-Corporation.ThingIFSDK"}.first
        versionString = b?.infoDictionary?["CFBundleShortVersionString"] as! String?
        if let v = versionString {
            kiiSDKHeader = "sn=it;sv=\(v);pv=\(UIDevice.currentDevice().systemVersion)"
        }
    }
}
