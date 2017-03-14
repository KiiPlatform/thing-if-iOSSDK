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
    private static let SHARED_NSUSERDEFAULT_SDK_VERSION_KEY =
      "GatewayAPI_VERSION"
    private static let MINIMUM_LOADABLE_SDK_VERSION = "1.0.0"


    private static func getStoredInstanceKey(_ tag : String?) -> String {
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }

    private static func getStoredSDKVersionKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_SDK_VERSION_KEY +
          (tag == nil ? "" : "_\(tag)")
    }

    // MARK: - Persistence.

    /** Try to load the instance of GatewayAPI using stored serialized instance.

     Instance is automatically saved when login method is called and
     successfully completed.

     If the GatewayAPI instance is build without the tag, all instance
     is saved in same place and overwritten when the instance is
     saved.

     If the GatewayAPI instance is build with the tag(optional), tag
     is used as key to distinguish the storage area to save the
     instance. This would be useful to saving multiple instance.

     When you catch exceptions, please call login for saving or
     updating serialized instance.

     - Parameter tag: tag of the GatewayAPI instance
     - Returns: GatewayIFAPI instance.
     */
    open static func loadWithStoredInstance(
      _ tag : String? = nil) throws -> GatewayAPI
    {
        let baseKey = GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let versionKey = GatewayAPI.getStoredSDKVersionKey(tag)
        let key = GatewayAPI.getStoredInstanceKey(tag)

        // try to get iotAPI from NSUserDefaults

        guard let dict =
                UserDefaults.standard.dictionary(forKey: baseKey) else {
            throw ThingIFError.apiNotStored(tag: tag)
        }

        if dict[key] == nil {
            throw ThingIFError.apiNotStored(tag: tag)
        }

        let storedSDKVersion = dict[versionKey] as? String
        if isLoadable(storedSDKVersion) == false {
            throw ThingIFError.apiUnloadable(
              tag: tag,
              storedVersion: storedSDKVersion,
              minimumVersion: MINIMUM_LOADABLE_SDK_VERSION)
        }

        guard let data = dict[key] as? Data else {
            throw ThingIFError.invalidStoredApi
        }
        guard let decoder = Decoder(data) else {
            throw ThingIFError.invalidStoredApi
        }
        guard let retval = GatewayAPI.deserialize(decoder) as? GatewayAPI else {
            throw ThingIFError.invalidStoredApi
        }

        return retval
    }

    /** Clear all saved instances in the NSUserDefaults.
     */
    open static func removeAllStoredInstances() -> Void
    {
        UserDefaults.standard.removeObject(
          forKey: GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE)
        UserDefaults.standard.synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.

     - Parameter tag: tag of the GatewayAPI instance or nil for default tag
     */
    open static func removeStoredInstances(
      _ tag : String? = nil) -> Void
    {
        if var dict = UserDefaults.standard.dictionary(
             forKey: GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE) {
            dict[GatewayAPI.getStoredSDKVersionKey(tag)] = nil
            dict[GatewayAPI.getStoredInstanceKey(tag)] = nil
            UserDefaults.standard.set(
              dict,
              forKey: GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE)
            UserDefaults.standard.synchronize()
        }
    }

    /** Save this instance

     This method use NSUserDefaults. Should not use the key
     "GatewayAPI_INSTANCE", this key is reserved.
     */
    open func saveInstance() -> Void {
        var coder = Coder()
        serialize(&coder)
        let data = coder.finishCoding()

        // NOTE: Getting dictionary from UserDefaults is redundant but
        // the data manytaimes is not saved without getting
        // first. This may be bug of iOS. We should investigate the
        // reason in future.
        // https://github.com/KiiPlatform/thing-if-iOSSDK/issues/221
        var dict = UserDefaults.standard.dictionary(
          forKey: GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE) ?? [ : ]
        dict[GatewayAPI.getStoredInstanceKey(self.tag)] = data
        dict[GatewayAPI.getStoredSDKVersionKey(self.tag)] =
          SDKVersion.sharedInstance.versionString

        UserDefaults.standard.set(
          dict,
          forKey: GatewayAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE)
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

        let minimumLoadableVersions =
          MINIMUM_LOADABLE_SDK_VERSION.components(separatedBy: ".")
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

extension GatewayAPI: Serializable {

    internal func serialize(_ coder: inout Coder) -> Void {
        coder.encode(self.app, forKey: "app")
        coder.encode(self.gatewayAddress, forKey: "gatewayAddress")
        coder.encode(self.accessToken, forKey: "accessToken")
        coder.encode(self.tag, forKey: "tag")
    }

    internal static func deserialize(_ decoder: Decoder) -> Serializable? {
        let retval = GatewayAPI(
          decoder.decodeSerializable(forKey: "app") as! KiiApp,
          gatewayAddress: decoder.decodeURL(forKey: "gatewayAddress")!,
          tag: decoder.decodeString(forKey: "tag"))
        retval.accessToken = decoder.decodeString(forKey: "accessToken")
        return retval
    }
}
