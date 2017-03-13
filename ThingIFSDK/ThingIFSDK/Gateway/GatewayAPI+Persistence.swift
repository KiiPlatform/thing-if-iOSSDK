//
//  GatewayAPI+Persistence.swift
//  ThingIFSDK
//
//  Created on 2017/03/13.
//  Copyright (c0 2017 Kii. All rights reserved.
//

import Foundation

extension GatewayAPI {

    private static let SHARED_NSUSERDEFAULT_KEY_INSTANCE = "GatewayAPI_INSTANCE"
    private static func getStoredInstanceKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }
    private static let SHARED_NSUSERDEFAULT_SDK_VERSION_KEY = "GatewayAPI_VERSION"
    private static func getStoredSDKVersionKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_SDK_VERSION_KEY + (tag == nil ? "" : "_\(tag)")
    }
    private static let MINIMUM_LOADABLE_SDK_VERSION = "0.13.0"

    /** Try to load the instance of GatewayAPI using stored serialized instance.

     Instance is automatically saved when login method is called and successfully completed.

     If the GatewayAPI instance is build without the tag, all instance is saved in same place
     and overwritten when the instance is saved.

     If the GatewayAPI instance is build with the tag(optional), tag is used as key to distinguish
     the storage area to save the instance. This would be useful to saving multiple instance.

     When you catch exceptions, please call login for saving or updating serialized instance.

     - Parameter tag: tag of the GatewayAPI instance
     - Returns: GatewayIFAPI instance.
     */
    open static func loadWithStoredInstance(_ tag : String? = nil) throws -> GatewayAPI?
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let versionKey = GatewayAPI.getStoredSDKVersionKey(tag)
        let key = GatewayAPI.getStoredInstanceKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            if dict.object(forKey: key) != nil {

                let storedSDKVersion = dict.object(forKey: versionKey) as? String
                if isLoadable(storedSDKVersion) == false {
                    throw ThingIFError.apiUnloadable(tag: tag, storedVersion: storedSDKVersion, minimumVersion: MINIMUM_LOADABLE_SDK_VERSION)
                }

                if let data = dict[key] as? Data {
                    if let savedAPI = NSKeyedUnarchiver.unarchiveObject(with: data) as? GatewayAPI {
                        return savedAPI
                    } else {
                        throw ThingIFError.invalidStoredApi
                    }
                } else {
                    throw ThingIFError.invalidStoredApi
                }
            } else {
                throw ThingIFError.apiNotStored(tag: tag)
            }
        } else {
            throw ThingIFError.apiNotStored(tag: tag)
        }
    }

    /** Clear all saved instances in the NSUserDefaults.
     */
    open static func removeAllStoredInstances()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        UserDefaults.standard.removeObject(forKey: baseKey)
        UserDefaults.standard.synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the GatewayAPI instance or nil for default tag
     */
    open static func removeStoredInstances(_ tag : String?=nil)
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let versionKey = GatewayAPI.getStoredSDKVersionKey(tag)
        let key = GatewayAPI.getStoredInstanceKey(tag)
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObject(forKey: versionKey)
            dict.removeObject(forKey: key)
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }
    }

    /** Save this instance
     This method use NSUserDefaults. Should not use the key "GatewayAPI_INSTANCE", this key is reserved.
     */
    open func saveInstance()
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let versionKey = GatewayAPI.getStoredSDKVersionKey(self.tag)
        let key = GatewayAPI.getStoredInstanceKey(self.tag)
        let data = NSKeyedArchiver.archivedData(withRootObject: self)

        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[versionKey] = SDKVersion.sharedInstance.versionString
            dict[key] = data
            UserDefaults.standard.set(dict, forKey: baseKey)
        } else {
            UserDefaults.standard.set(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        UserDefaults.standard.synchronize()
    }

    private static func isLoadable(_ storedSDKVersion: String?) -> Bool {
        if storedSDKVersion == nil {
            return false
        }

        let actualVersions = storedSDKVersion!.components(separatedBy: ".")
        if actualVersions.count != 3 {
            return false
        }

        let minimumLoadableVersions = MINIMUM_LOADABLE_SDK_VERSION.components(separatedBy: ".")
        for i in 0..<3 {
            let actual = Int(actualVersions[i])!
            let expect = Int(minimumLoadableVersions[i])!
            if actual < expect {
                return false
            } else if actual > expect {
                break
            }
        }

        return true
    }

}
