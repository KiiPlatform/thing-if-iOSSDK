//
//  IoTCloudAPI.swift
//  IoTCloudSDK
//

import Foundation

/** Class provides API of the IoTCloud. */
public class IoTCloudAPI: NSObject, NSCoding {

    private static let SHARED_NSUSERDEFAULT_KEY_INSTANCE = "IoTCloudAPI_INSTANCE"
    private static func getSharedNSDefaultKey(tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }

    let tag : String?

    let operationQueue = OperationQueue()
    /** URL of KiiApps Server */
    public let baseURL: String!
    /** The application ID found in your Kii developer console */
    public let appID: String!
    /** The application key found in your Kii developer console */
    public let appKey: String!
    /** owner of target */
    public let owner: Owner!

    var _installationID:String?
    var _target: Target?

    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.

    - Returns: Installation ID used in IoT Cloud.
    */
    public var installationID: String? {
        get {
            return _installationID
        }
    }

    /** target */
    public var target: Target? {
        get {
            return _target
        }
    }

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.baseURL, forKey: "baseURL")
        aCoder.encodeObject(self.appID, forKey: "appID")
        aCoder.encodeObject(self.appKey, forKey: "appKey")
        aCoder.encodeObject(self.owner, forKey: "owner")
        aCoder.encodeObject(self._installationID, forKey: "_installationID")
        aCoder.encodeObject(self._target, forKey: "_target")
        aCoder.encodeObject(self.tag, forKey: "tag")
    }

    public required init(coder aDecoder: NSCoder) {
        self.baseURL = aDecoder.decodeObjectForKey("baseURL") as! String
        self.appID = aDecoder.decodeObjectForKey("appID") as! String
        self.appKey = aDecoder.decodeObjectForKey("appKey") as! String
        self.owner = aDecoder.decodeObjectForKey("owner") as! Owner
        self._installationID = aDecoder.decodeObjectForKey("_installationID") as? String
        self._target = aDecoder.decodeObjectForKey("_target") as? Target
        self.tag = aDecoder.decodeObjectForKey("tag") as? String
    }

    init(baseURL: String, appID: String, appKey: String, owner: Owner, tag : String?=nil) {
        self.baseURL = baseURL
        self.appID = appID
        self.appKey = appKey
        self.owner = owner
        self.tag = tag
        super.init()
        self.saveToUserDefault()
    }

    // MARK: - On board methods

    /** On board IoT Cloud with the specified vendor thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of IoTCloudAPI instance.)
    
    **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, IoTCloudError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter vendorThingID: Thing ID given by vendor. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter thingType: Type of the thing given by vendor.
    If the thing is already registered,
    this value would be ignored by IoT Cloud.
    - Parameter thingProperties: Properties of thing.
    If the thing is already registered, this value would be ignored by
    IoT Cloud.
    Refer to the [REST API DOC](http://docs.kii.com/rest/#thing_management-register_a_thing)
    About the format of this Document.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an IoTCloudError
    */
    public func onboard(
        vendorThingID:String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) ->Void
    {
        _onboard(true, IDString: vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { (target, error) -> Void in
            completionHandler(target, error)
        }
    }
    
    /** On board IoT Cloud with the specified thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of IoTCloudAPI instance.)
    When you're sure that the on board process has been done,
    this method is convenient.

    **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, IoTCloudError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an IoTCloudError
    */
    public func onboard(
        thingID:String,
        thingPassword:String,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) ->Void
    {
         _onboard(false, IDString: thingID, thingPassword: thingPassword, thingType: nil, thingProperties: nil) { (target, error) -> Void in
            completionHandler(target, error)
        }
    }

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT Cloud.
    IoT Cloud will send notification when the Target replies to the Command.
    Application can receive the notification and check the result of Command
    fired by Application or registered Trigger.
    After installation is done Installation ID is managed in this class.

    - Parameter deviceToken: device token for APNS.
    - Parameter development: flag indicate whether the cert is development or
    production.
    - Parameter completionHandler: A closure to be executed once on board has finished.
    */
    public func installPush(
        deviceToken:String,
        development:Bool,
        completionHandler: (String?, IoTCloudError?)-> Void
        )
    {
        _installPush(deviceToken, development: development, completionHandler: completionHandler)
        
    }
    
    /** Uninstall push notification.
    After done, notification from IoT Cloud won't be notified.

    - Parameter installationID: installation ID returned from installPush().
    If null is specified, value of the installationID property is used.
    */
    public func uninstallPush(
        installationID:String?,
        completionHandler: (IoTCloudError?)-> Void
        )
    {
        _uninstallPush(installationID, completionHandler: completionHandler)
    }
    

    // MARK: - Command methods

    /** Post new command to IoT Cloud.
    Command will be delivered to specified target and result will be notified
    through push notification.
    
    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
    
    - Parameter schemaName: Name of the Schema of which the Command is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command is
    defined.
    - Parameter actions: List of Actions to be executed in the Target.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed.
    */
    public func postNewCommand(
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String,AnyObject>],
        completionHandler: (Command?, IoTCloudError?)-> Void
        ) -> Void
    {
        _postNewCommand(schemaName, schemaVersion: schemaVersion, actions: actions, completionHandler: completionHandler)
    }
    
    /** Get specified command

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter commandID: ID of the Command to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed.
     */
    public func getCommand(
        commandID:String,
        completionHandler: (Command?, IoTCloudError?)-> Void
        )
    {
        _getCommand(commandID, completionHandler: completionHandler)
    }
    
    /** List Commands in the specified Target.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter bestEffortLimit: Limit the maximum number of the Commands in the
    Response. If omitted default limit internally defined is applied.
    Meaning of 'bestEffort' is if specified value is greater than default limit,
    default limit is applied.
    - Parameter paginationKey: If there is further page to be retrieved, this
    API returns paginationKey in sencond element. Specifying this value in next
    call results continue to get the results from the next page.
    - Returns: Where 1st element is Array of the commands
    belongs to the Target. 2nd element is paginationKey if there is further page
    to be retrieved.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Commands if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of IoTCloudError when failed.
     */
    public func listCommands(
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: ([Command]?, String?, IoTCloudError?)-> Void
        )
    {
        _listCommands(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }

    // MARK: - Trigger methods

    /** Post new Trigger to IoT Cloud.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter schemaName: Name of the Schema of which the Command specified in
    Trigger is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command
    specified in Trigger is defined.
    - Parameter actions: Actions to be executed by the Trigger.
    - Parameter predicate: Predicate of the Command.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is an created Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func postNewTrigger(
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, AnyObject>],
        predicate:Predicate,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _postNewTrigger(schemaName, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: completionHandler)
    }

    /** Get specified trigger

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of Trigger, an instance of IoTCloudError when failed.
    */
    public func getTrigger(
        triggerID:String,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _getTrigger(triggerID, completionHandler: completionHandler)
    }


    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to which the patch is applied.
    - Parameter schemaName: Name of the Schema of which the Command specified in
    Trigger is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command
    specified in Trigger is defined.
    - Parameter actions: Modified Actions to be applied as patch.
    - Parameter predicate: Modified Predicate to be applied as patch.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the modified Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func patchTrigger(
        triggerID:String,
        schemaName:String?,
        schemaVersion:Int?,
        actions:[Dictionary<String, AnyObject>]?,
        predicate:Predicate?,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _patchTrigger(triggerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: completionHandler)
    }
    
    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the enabled/disabled Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func enableTrigger(
        triggerID:String,
        enable:Bool,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _enableTrigger(triggerID, enable: enable, completionHandler: completionHandler)
    }
    
    /** Delete a registered Trigger.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be deleted.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the deleted Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func deleteTrigger(
        triggerID:String,
        completionHandler: (Trigger!, IoTCloudError?)-> Void
        )
    {
        _deleteTrigger(triggerID, completionHandler: completionHandler)
    }
    
    /** List Triggers belongs to the specified Target

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter bestEffortLimit: Limit the maximum number of the Triggers in the
    Response. If omitted default limit internally defined is applied.
    Meaning of 'bestEffort' is if specified value is greater than default limit,
    default limit is applied.
    - Parameter paginationKey: If there is further page to be retrieved, this
    API returns paginationKey in 2nd element. Specifying this value in next
    call in the argument results continue to get the results from the next page.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Triggers instance if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of IoTCloudError when failed.
    */
    public func listTriggers(
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (triggers:[Trigger]?, paginationKey:String?, error: IoTCloudError?)-> Void
        )
    {
        _listTriggers(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }

    // MARK: - Get the state of specified target

    /** Get the state of specified target.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter completionHandler: A closure to be executed once get state has finished. The closure takes 2 arguments: 1st one is Dictionary that represent Target State and 2nd one is an instance of IoTCloudError when failed.
    */
    public func getState(
        completionHandler: (Dictionary<String, AnyObject>?,  IoTCloudError?)-> Void
        )
    {
        _getState(completionHandler)
        
    }

    // MARK: - Copy with new target instance 

    /** Get new instance with new target

    - Parameter newTarget: target instance will be setted to new IoTCloudAPI instance
    - Returns: New IoTCloudAPI instance with newTarget
    */
    public func copyWithTarget(newTarget: Target) -> IoTCloudAPI {

        let newIotapi = IoTCloudAPI(baseURL: self.baseURL, appID: self.appID, appKey: self.appKey, owner: self.owner)

        newIotapi._target = newTarget
        newIotapi._installationID = self._installationID

        return newIotapi
    }

    /** Try to load the instance of IoTCloudAPI using stored serialized instance.

    - Parameter tag: tag of the IoTCloudAPI instance
    - Returns: IoTCloudAPI instance.
    */
    public static func loadWithStoredInstance(tag : String? = nil) throws -> IoTCloudAPI?{
        let baseKey = IoTCloudAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = IoTCloudAPI.getSharedNSDefaultKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary
        {
            if let data = dict[key] as? NSData {
                if let savedIoTAPI = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? IoTCloudAPI {
                    return savedIoTAPI
                }else{
                    throw IoTCloudError.INVALID_STORED_API
                }
            }else{
                throw IoTCloudError.INVALID_STORED_API
            }

        }else{
            throw IoTCloudError.API_NOT_STORED
        }
    }

    /** Clear all saved instances in the NSUserDefaults.
    */
    public static func removeAllStoredInstances(){
        let baseKey = IoTCloudAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        NSUserDefaults.standardUserDefaults().removeObjectForKey(baseKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    /** Remove saved specified instance in the NSUserDefaults.
    - Parameter tag: tag of the IoTCloudAPI instance or nil for default tag
    */
    public static func removeStoredInstances(tag : String?=nil){
        let baseKey = IoTCloudAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = IoTCloudAPI.getSharedNSDefaultKey(tag)
        if let tempdict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObjectForKey(key)
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: baseKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    func saveToUserDefault(){

        let baseKey = IoTCloudAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let key = IoTCloudAPI.getSharedNSDefaultKey(self.tag)
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)

        if let tempdict = NSUserDefaults.standardUserDefaults().objectForKey(baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[key] = data
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: baseKey)
        }else{
            NSUserDefaults.standardUserDefaults().setObject(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let anAPI = object as? IoTCloudAPI else{
            return false
        }

        return self.appID == anAPI.appID &&
            self.appKey == anAPI.appKey &&
            self.baseURL == anAPI.baseURL &&
            self.target == anAPI.target &&
            self.installationID == anAPI.installationID &&
            self.tag == anAPI.tag
    }

    
}