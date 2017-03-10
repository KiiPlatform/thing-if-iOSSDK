//
//  ThingIFAPI+Persistence.swift
//  ThingIFSDK
//
//  Created on 2017/03/09.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {

    private static var SHARED_NSUSERDEFAULT_KEY_INSTANCE: String {
        get {
            return "ThingIFAPI_INSTANCE"
        }
    }

    private static func getStoredInstanceKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag!)")
    }

    private static var SHARED_NSUSERDEFAULT_SDK_VERSION_KEY: String {
        get {
            return "ThingIFAPI_VERSION"
        }
    }

    private static func getStoredSDKVersionKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_SDK_VERSION_KEY + (tag == nil ? "" : "_\(tag!)")
    }

    private static var MINIMUM_LOADABLE_SDK_VERSION: String {
        get {
            return "1.0.0"
        }
    }

    // MARK: - Persistence.

    /** Try to load the instance of ThingIFAPI using stored serialized instance.

    Instance is automatically saved when following methods are called.
    onboard, onboardWithVendorThingID, copyWithTarget and installPush
    has been successfully completed.
    (When copyWithTarget is called, only the copied instance is saved.)

    If the ThingIFAPI instance is build without the tag, all instance is saved in same place
    and overwritten when the instance is saved.

    If the ThingIFAPI instance is build with the tag(optional), tag is used as key to distinguish
    the storage area to save the instance. This would be useful to saving multiple instance.

    When you catch exceptions, please call onload for saving or updating serialized instance.

    - Parameter tag: tag of the ThingIFAPI instance
    - Returns: ThingIFAPI instance.
    */
    open static func loadWithStoredInstance(_ tag : String? = nil) throws -> ThingIFAPI?{
        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let versionKey = ThingIFAPI.getStoredSDKVersionKey(tag)
        let key = ThingIFAPI.getStoredInstanceKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary
        {
            if dict.object(forKey: key) != nil {

                let storedSDKVersion = dict.object(forKey: versionKey) as? String
                if isLoadable(storedSDKVersion) == false {
                    throw ThingIFError.apiUnloadable(tag: tag, storedVersion: storedSDKVersion, minimumVersion: MINIMUM_LOADABLE_SDK_VERSION)
                }

                if let data = dict[key] as? Data {
                    if let savedIoTAPI =
                         ThingIFAPI.deserialize(Decoder(data)) as? ThingIFAPI {
                        return savedIoTAPI
                    }else{
                        throw ThingIFError.invalidStoredApi
                    }
                }else{
                    throw ThingIFError.invalidStoredApi
                }
            } else {
                throw ThingIFError.apiNotStored(tag: tag)
            }
        }else{
            throw ThingIFError.apiNotStored(tag: tag)
        }
    }
    /** Save this instance
    */
    open func saveInstance() -> Void {
        self.saveToUserDefault()
    }

    /** Clear all saved instances in the NSUserDefaults.
    */
    open static func removeAllStoredInstances(){
        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        UserDefaults.standard.removeObject(forKey: baseKey)
        UserDefaults.standard.synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.
    - Parameter tag: tag of the ThingIFAPI instance or nil for default tag
    */
    open static func removeStoredInstances(_ tag : String?=nil){
        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let versionKey = ThingIFAPI.getStoredSDKVersionKey(tag)
        let key = ThingIFAPI.getStoredInstanceKey(tag)
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObject(forKey: versionKey)
            dict.removeObject(forKey: key)
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }
    }

    internal func saveToUserDefault(){
        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let versionKey = ThingIFAPI.getStoredSDKVersionKey(self.tag)
        let key = ThingIFAPI.getStoredInstanceKey(self.tag)
        var coder = Coder()
        serialize(&coder)
        let data = coder.finishCoding()

        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[versionKey] = SDKVersion.sharedInstance.versionString
            dict[key] = data
            UserDefaults.standard.set(dict, forKey: baseKey)
        }else{
            UserDefaults.standard.set(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        UserDefaults.standard.synchronize()
    }

    static func isLoadable(_ storedSDKVersion: String?) -> Bool {
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

extension ThingIFAPI: Serializable {

    internal func serialize(_ coder: inout Coder) -> Void {
        coder.encode(self.app, forKey: "app")
        coder.encode(self.owner, forKey: "owner")
        coder.encode(self.installationID, forKey: "_installationID")
        coder.encode(self.target as? Serializable, forKey: "_target")
        coder.encode(self.tag, forKey: "tag")
    }

    internal static func deserialize(_ decoder: Decoder) -> Serializable? {
        let retval = ThingIFAPI(
          decoder.decodeSerializable(forKey: "app") as! KiiApp,
          owner: decoder.decodeSerializable(forKey: "owner") as! Owner,
          target: decoder.decodeSerializable(forKey: "_target") as? Target,
          tag: decoder.decodeString(forKey: "tag"))
        retval.installationID = decoder.decodeString(forKey: "_installationID")
        return retval
    }
}
