//
//  IoTCloudAPI.swift
//  IoTCloudSDK
//

import Foundation

/** Class provides API of the IoTCloud. */
public class IoTCloudAPI: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement it.
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        super.init()
        // TODO: implement it.
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
    - Returns: Target instance can be used to perate target,
    manage resources of the Target.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func onBoard(
        vendorThingID:String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,Any>?
        ) throws -> Target!
    {
        // TODO: implement it.
        return Target()
    }

    /** On board IoT Cloud with the specified thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of IoTCloudAPI instance.)
    When you're sure that the on board process has been done,
    this method is convenient.
    
    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Returns: Target instance can be used to perate target,
    manage resources of the Target.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func onBoard(
        thingID:String,
        thingPassword:String
        ) throws -> Target!
    {
        // TODO: implement it.
        return Target()
    }

    /** Install push notification to receive notification from IoT Cloud.
    IoT Cloud will send notification when the Target replies to the Command.
    Application can receive the notification and check the result of Command
    fired by Application or registered Trigger.
    After installation is done Installation ID is managed in this class.
    - Parameter deviceToken: device token for APNS.
    - Parameter development: flag indicate whether the cert is development or
    production.
    - Returns: installationID published by IoT Cloud.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func installPush(
        deviceToken:String,
        development:Bool
    ) throws -> String!
    {
        // TODO: implement it.
        return ""
    }

    /** Uninstall push notification.
    After done, notification from IoT Cloud won't be notified.
    - Parameter installationID: installation ID returned from installPush().
    If null is specified, value of the installationID property is used.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func uninstallPush(
        installationID:String?
    ) throws
    {
        // TODO: implement it.
    }

    private var _installationID:String?

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
    - Parameter issuer: Specify command issuer. If execute command as group,
    you can use group:{gropuID} as issuer.
    If nil is specified owner of the IoTCloudAPI is regarded as issuer.
    - Returns: Instance of created command.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func postNewCommand(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, Any>],
        issuer:TypedID?
        ) throws -> Command!
    {
        // TODO: implement it.
        return Command()
    }

    /** Get specified command
    
    - Parameter target: Target of the Command.
    - Parameter commandID: ID of the Command to obtain.
    - Returns: Instance of obtained Command.
    - Throws: IoTCloudError when failed to connect to internet or IoT Cloud
    Server returns error.
     */
    public func getCommand(
        target:Target,
        commandID:String
        ) throws -> Command
    {
        // TODO: implement it.
        return Command()
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
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
     */
    public func listCommands(
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?
        ) throws -> ([Command], String?)
    {
        // TODO: implement it.
        return ([],"")
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
    - Parameter issuer: Issuer of the Command.
    - Parameter predicate: Predicate of the Command.
    - Returns: Created Trigger Instance.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
     */
    public func postNewTrigger(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, Any>],
        issuer:TypedID,
        predicate:Predicate
        ) throws -> Trigger
    {
        // TODO: implement it.
        return Trigger()
    }

    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.
    - Parameter target: Target to which the Trigger belongs.
    - Parameter triggerID: ID of the Trigger to which the patch is applied.
    - Parameter actions: Modified Actions to be applied as patch.
    - Parameter predicate: Modified Predicate to be applied as patch.
    - Returns: Modified Trigger instance.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
    */
    public func patchTrigger(
        target:Target,
        triggerID:String,
        actions:[Dictionary<String, Any>]?,
        predicate:Predicate?
        ) throws -> Trigger
    {
        // TODO: implement it.
        return Trigger()
    }

    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.
    - Parameter target: Target to which the Trigger belongs.
    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Returns: Enabled/Disabled Trigger instance.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
    */
    public func enableTrigger(
        target:Target,
        triggerID:String,
        enable:Bool
        ) throws -> Trigger
    {
        // TODO: implement it.
        return Trigger()
    }

    /** Delete a registered Trigger.
    - Parameter target: Target to which the Trigger belongs.
    - Parameter triggerID: ID of the Trigger to be deleted.
    Returns deleted Trigger instance.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
    */
    public func deleteTrigger(
        target:Target,
        triggerID:String
    ) throws -> Trigger
    {
        // TODO: implement it.
        return Trigger()
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
    - Returns: Where 1st element is Array of the Triggers
    belongs to the Target. 2nd element is paginationKey if there is further page
    to be retrieved.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
    */
    public func listTriggers(
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?
        ) throws -> ([Trigger], String?)
    {
        // TODO: implement it.
        return ([],"")
    }

    /** Get the state of specified target.
    - Parameter target: Specify Target to which the State is bound.
    - Returns: State object.
    - Throws: IoTCloudError when failed to connect to internet or
    IoT Cloud Server returns error.
    */
    public func getState(
        target:Target
    ) throws -> Dictionary<String, Any>
    {
        // TODO: implement it.
        return ["power":false]
    }

}