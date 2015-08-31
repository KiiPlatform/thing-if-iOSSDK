//
//  IoTCloudAPI.swift
//  IoTCloudSDK
//

import Foundation

/** Class provides API of the IoTCloud. */
public class IoTCloudAPI: NSObject, NSCoding {
    
    let operationQueue = OperationQueue()
    public var baseURL: String!
    public var appID: String!
    public var appKey: String!
    public var owner: Owner!
    
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.baseURL, forKey: "baseURL")
        aCoder.encodeObject(self.appID, forKey: "appID")
        aCoder.encodeObject(self.appKey, forKey: "appKey")
        aCoder.encodeObject(self.owner, forKey: "owner")
    }
    
    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.baseURL = aDecoder.decodeObjectForKey("baseURL") as! String
        self.appID = aDecoder.decodeObjectForKey("appID") as! String
        self.appKey = aDecoder.decodeObjectForKey("appKey") as! String
        self.owner = aDecoder.decodeObjectForKey("owner") as! Owner
    }
    
    public override init() {
        // TODO: define proper initializer.
    }
    
    /** On board IoT Cloud with the specified vendor thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of IoTCloudAPI instance.)
    
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
    public func onBoard(
        vendorThingID:String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) ->Void
    {
        _onBoard(true, IDString: vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { (target, error) -> Void in
            completionHandler(target, error)
        }
    }
    
    /** On board IoT Cloud with the specified thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of IoTCloudAPI instance.)
    When you're sure that the on board process has been done,
    this method is convenient.
    
    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an IoTCloudError
    */
    public func onBoard(
        thingID:String,
        thingPassword:String,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) ->Void
    {
         _onBoard(false, IDString: thingID, thingPassword: thingPassword, thingType: nil, thingProperties: nil) { (target, error) -> Void in
            completionHandler(target, error)
        }
    }
    
    //TODO: fix documentation
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
    
    var _installationID:String?
    
    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.
    - Returns: Installation ID used in IoT Cloud.
    */
    public var installationID: String? {
        get {
            return _installationID
        }
    }
    
    /** Post new command to IoT Cloud.
    Command will be delivered to specified target and result will be notified
    through push notification.
    
    - Parameter target: Target of the command to be delivered.
    - Parameter schemaName: Name of the Schema of which the Command is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command is
    defined.
    - Parameter actions: List of Actions to be executed in the Target.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed.
    */
    public func postNewCommand(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String,AnyObject>],
        completionHandler: (Command?, IoTCloudError?)-> Void
        ) -> Void
    {
        _postNewCommand(target, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, completionHandler: completionHandler)
    }
    
    /** Get specified command
    
    - Parameter target: Target of the Command.
    - Parameter commandID: ID of the Command to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed.
     */
    public func getCommand(
        target:Target,
        commandID:String,
        completionHandler: (Command?, IoTCloudError?)-> Void
        )
    {
        _getCommand(target, commandID: commandID, completionHandler: completionHandler)
    }
    
    /** List Commands in the specified Target.
    
    - Parameter target: Target to which Commands belong
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
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: ([Command]?, String?, IoTCloudError?)-> Void
        )
    {
        _listCommands(target, bestEffortLimit: bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }
    
    /** Post new Trigger to IoT Cloud.
    
    - Parameter target: Target of which the trigger stored.
    It the trigger is based on state of target, Trigger is evaluated when the
    state of the target has been updated.
    - Parameter schemaName: Name of the Schema of which the Command specified in
    Trigger is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command
    specified in Trigger is defined.
    - Parameter actions: Actions to be executed by the Trigger.
    - Parameter predicate: Predicate of the Command.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is an created Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func postNewTrigger(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, AnyObject>],
        predicate:Predicate,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _postNewTrigger(target, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: completionHandler)
    }

    /** Get specified trigger

    - Parameter target: Target of the Trigger.
    - Parameter triggerID: ID of the Trigger to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of Trigger, an instance of IoTCloudError when failed.
    */
    public func getTrigger(
        target:Target,
        triggerID:String,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _getTrigger(target, triggerID: triggerID, completionHandler: completionHandler)
    }


    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.
    - Parameter target: Target to which the Trigger belongs.
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
        target:Target,
        triggerID:String,
        schemaName:String?,
        schemaVersion:Int?,
        actions:[Dictionary<String, AnyObject>]?,
        predicate:Predicate?,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _patchTrigger(target, triggerID: triggerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: completionHandler)
    }
    
    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.
    - Parameter target: Target to which the Trigger belongs.
    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the enabled/disabled Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func enableTrigger(
        target:Target,
        triggerID:String,
        enable:Bool,
        completionHandler: (Trigger?, IoTCloudError?)-> Void
        )
    {
        _enableTrigger(target, triggerID: triggerID, enable: enable, completionHandler: completionHandler)
    }
    
    /** Delete a registered Trigger.
    - Parameter target: Target to which the Trigger belongs.
    - Parameter triggerID: ID of the Trigger to be deleted.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the deleted Trigger instance, 2nd one is an IoTCloudError instance when failed.
    */
    public func deleteTrigger(
        target:Target,
        triggerID:String,
        completionHandler: (Trigger!, IoTCloudError?)-> Void
        )
    {
        _deleteTrigger(target, triggerID: triggerID, completionHandler: completionHandler)
    }
    
    /** List Triggers belongs to the specified Target
    - Parameter target: Target to which the Triggers belongs.
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
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (triggers:[Trigger]?, paginationKey:String?, error: IoTCloudError?)-> Void
        )
    {
        _listTriggers(target, bestEffortLimit: bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }
    
    /** Get the state of specified target.
    - Parameter target: Specify Target to which the State is bound.
    - Parameter completionHandler: A closure to be executed once get state has finished. The closure takes 2 arguments: 1st one is Dictionary that represent Target State and 2nd one is an instance of IoTCloudError when failed.
    */
    public func getState(
        target:Target!,
        completionHandler: (Dictionary<String, AnyObject>?,  IoTCloudError?)-> Void
        )
    {
        _getState(target, completionHandler: completionHandler)
        
    }
    
}