//
//  ThingIFAPI.swift
//  ThingIFSDK
//

import Foundation

/** Class provides API of the ThingIF. */
open class ThingIFAPI: NSObject, NSCoding {

    fileprivate static let SHARED_NSUSERDEFAULT_KEY_INSTANCE = "ThingIFAPI_INSTANCE"
    fileprivate static func getSharedNSDefaultKey(_ tag : String?) -> String{
        return SHARED_NSUSERDEFAULT_KEY_INSTANCE + (tag == nil ? "" : "_\(tag)")
    }

    /** Tag of the ThingIFAPI instance */
    open let tag : String?

    let operationQueue = OperationQueue()
    /** URL of KiiApps Server */
    open let baseURL: String!
    /** The application ID found in your Kii developer console */
    open let appID: String!
    /** The application key found in your Kii developer console */
    open let appKey: String!
    /** Kii Cloud Application */
    open let app: App!
    /** owner of target */
    open let owner: Owner!

    var _installationID:String?
    var _target: Target?

    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.

    - Returns: Installation ID used in IoT Cloud.
    */
    open var installationID: String? {
        get {
            return _installationID
        }
    }

    /** target */
    open var target: Target? {
        get {
            return _target
        }
    }

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.app, forKey: "app")
        aCoder.encode(self.baseURL, forKey: "baseURL")
        aCoder.encode(self.appID, forKey: "appID")
        aCoder.encode(self.appKey, forKey: "appKey")
        aCoder.encode(self.owner, forKey: "owner")
        aCoder.encode(self._installationID, forKey: "_installationID")
        aCoder.encode(self._target, forKey: "_target")
        aCoder.encode(self.tag, forKey: "tag")
    }

    public required init(coder aDecoder: NSCoder){
        self.app = aDecoder.decodeObject(forKey: "app") as! App
        self.baseURL = aDecoder.decodeObject(forKey: "baseURL") as! String
        self.appID = aDecoder.decodeObject(forKey: "appID") as! String
        self.appKey = aDecoder.decodeObject(forKey: "appKey") as! String
        self.owner = aDecoder.decodeObject(forKey: "owner") as! Owner
        self._installationID = aDecoder.decodeObject(forKey: "_installationID") as? String
        self._target = aDecoder.decodeObject(forKey: "_target") as? Target
        self.tag = aDecoder.decodeObject(forKey: "tag") as? String
    }

    init(app:App, owner: Owner, tag : String?=nil) {
        self.app = app
        self.baseURL = app.baseURL
        self.appID = app.appID
        self.appKey = app.appKey
        self.owner = owner
        self.tag = tag
        super.init()
    }

    // MARK: - On board methods

    /** On board IoT Cloud with the specified vendor thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of ThingIFAPI instance.)
    If you are using a gateway, you need to use onboardEndnodeWithGateway to onboard endnode instead.
    
    **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

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
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an ThingIFError
    */
    open func onboard(
        _ vendorThingID:String,
        thingPassword:String,
        thingType:String?,
        thingProperties:Dictionary<String,AnyObject>?,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        _onboard(true, IDString: vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { (target, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(target, error)
        }
    }
    
    /** On board IoT Cloud with the specified vendor thing ID.
     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of ThingIFAPI instance.)
     If you are using a gateway, you need to use onboardEndnodeWithGateway to onboard endnode instead.

     **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter vendorThingID: Thing ID given by vendor. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor. Must be specified.
    - Parameter options: Optional parameters inside.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an ThingIFError
    */
    open func onboardWithVendorThingID(
        _ vendorThingID:String,
        thingPassword:String,
        options:OnboardWithVendorThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        _onboard(true, IDString: vendorThingID, thingPassword: thingPassword,
            thingType: options?.thingType,
            firmwareVersion: options?.firmwareVersion,
            thingProperties: options?.thingProperties,
            layoutPosition: options?.layoutPosition,
            dataGroupingInterval: options?.dataGroupingInterval) { (target, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(target, error)
        }
    }

    /** On board IoT Cloud with the specified thing ID.
    Specified thing will be owned by owner who consumes this API.
    (Specified on creation of ThingIFAPI instance.)
    When you're sure that the on board process has been done,
    this method is convenient.
     If you are using a gateway, you need to use onboardEndnodeWithGateway to onboard endnode instead.

    **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an ThingIFError
    */
    open func onboard(
        _ thingID:String,
        thingPassword:String,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
         _onboard(false, IDString: thingID, thingPassword: thingPassword) { (target, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(target, error)
        }
    }

    /** On board IoT Cloud with the specified thing ID.
     Specified thing will be owned by owner who consumes this API.
     (Specified on creation of ThingIFAPI instance.)
     When you're sure that the on board process has been done,
     this method is convenient.
     If you are using a gateway, you need to use onboardEndnodeWithGateway to onboard endnode instead.

     **Note**: You should not call onboard second time, after successfully onboarded. Otherwise, ThingIFError.ALREADY_ONBOARDED will be returned in completionHandler callback.

    - Parameter thingID: Thing ID given by IoT Cloud. Must be specified.
    - Parameter thingPassword: Thing Password given by vendor.
    Must be specified.
    - Parameter options: Optional parameters inside.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an ThingIFError
     */
    open func onboardWithThingID(
        _ thingID:String,
        thingPassword:String,
        options:OnboardWithThingIDOptions? = nil,
        completionHandler: @escaping (Target?, ThingIFError?)-> Void
        ) ->Void
    {
        _onboard(false, IDString: thingID, thingPassword: thingPassword,
            layoutPosition: options?.layoutPosition,
            dataGroupingInterval: options?.dataGroupingInterval) { (target, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(target, error)
        }
    }

    /** Endpoints execute onboarding for the thing and merge MQTT channel to the gateway.
     Thing act as Gateway is already registered and marked as Gateway.
    
     - Parameter pendingEndnode: Pending End Node
     - Parameter endnodePassword: Password of the End Node
     - Parameter options: Optional parameters inside.
     - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an end node, an ThingIFError
     */
    open func onboardEndnodeWithGateway(
        _ pendingEndnode:PendingEndNode,
        endnodePassword:String,
        options:OnboardEndnodeWithGatewayOptions? = nil,
        completionHandler: (EndNode?, ThingIFError?)-> Void
        ) ->Void
    {
        _onboardEndnodeWithGateway(pendingEndnode,
            endnodePassword: endnodePassword,
            options: options,
            completionHandler: completionHandler)
    }

    // MARK: - Push notification methods

    /** Install push notification to receive notification from IoT Cloud.
    IoT Cloud will send notification when the Target replies to the Command.
    Application can receive the notification and check the result of Command
    fired by Application or registered Trigger.
    After installation is done Installation ID is managed in this class.

    - Parameter deviceToken: NSData instance of device token for APNS.
    - Parameter development: flag indicate whether the cert is development or
    production. This is optional, the default is false (production).
    - Parameter completionHandler: A closure to be executed once on board has finished.
    */
    open func installPush(
        _ deviceToken:Data,
        development:Bool?=false,
        completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        _installPush(deviceToken, development: development) { (token, error) -> Void in
            if error == nil {
                self.saveToUserDefault()
            }
            completionHandler(token, error)
        }
    }
    
    /** Uninstall push notification.
    After done, notification from IoT Cloud won't be notified.

    - Parameter installationID: installation ID returned from installPush().
    If null is specified, value of the installationID property is used.
    */
    open func uninstallPush(
        _ installationID:String?,
        completionHandler: (ThingIFError?)-> Void
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
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of ThingIFError when failed.
    */
    open func postNewCommand(
        _ schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String,AnyObject>],
        completionHandler: (Command?, ThingIFError?)-> Void
        ) -> Void
    {
        _postNewCommand(schemaName, schemaVersion: schemaVersion, actions: actions, completionHandler: completionHandler)
    }

    /** Post new command to IoT Cloud.
    Command will be delivered to specified target and result will be notified
    through push notification.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter commandForm: Command form of posting command.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of ThingIFError when failed.
    */
    open func postNewCommand(
        _ commandForm: CommandForm,
        completionHandler: (Command?, ThingIFError?) -> Void) -> Void {
        _postNewCommand(commandForm.schemaName,
                        schemaVersion: commandForm.schemaVersion,
                        actions: commandForm.actions,
                        title: commandForm.title,
                        description: commandForm.commandDescription,
                        metadata: commandForm.metadata,
                        completionHandler: completionHandler);
    }

    /** Get specified command

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter commandID: ID of the Command to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of created command, an instance of ThingIFError when failed.
     */
    open func getCommand(
        _ commandID:String,
        completionHandler: (Command?, ThingIFError?)-> Void
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
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Commands if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
     */
    open func listCommands(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: ([Command]?, String?, ThingIFError?)-> Void
        )
    {
        _listCommands(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }

    // MARK: - Trigger methods

    /** Post new Trigger to IoT Cloud.

    **Note**: Please onboard first, or provide a target instance by
      calling copyWithTarget. Otherwise,
      KiiCloudError.TARGET_NOT_AVAILABLE will be return in
      completionHandler callback

    When thing related to this ThingIFAPI instance meets condition
    described by predicate, A registered command sends to thing
    related to `TriggeredCommandForm.targetID`.

    `target` property and `TriggeredCommandForm.targetID` must be same
    owner's things.

    - Parameter triggeredCommandForm: Triggered command form of posting trigger.
    - Parameter predicate: Predicate of this trigger.
    - Parameter options: Optional data for this trigger.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: 1st one is an created
      Trigger instance, 2nd one is an ThingIFError instance when
      failed.
    */
    open func postNewTrigger(
        _ triggeredCommandForm:TriggeredCommandForm,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: (Trigger?, ThingIFError?) -> Void)
    {
        _postNewTrigger(triggeredCommandForm,
                        predicate: predicate,
                        options: options,
                        completionHandler: completionHandler);
    }

    /** Post new Trigger to IoT Cloud.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    When thing related to this ThingIFAPI instance meets condition
    described by predicate, A registered command sends to thing
    related to target.

    `target` property and target argument must be same owner's things.

    - Parameter schemaName: Name of the Schema of which the Command specified in
    Trigger is defined.
    - Parameter schemaVersion: Version of the Schema of which the Command
    specified in Trigger is defined.
    - Parameter actions: Actions to be executed by the Trigger.
    - Parameter predicate: Predicate of the Command.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is an created Trigger instance, 2nd one is an ThingIFError instance when failed.
    */
    open func postNewTrigger(
        _ schemaName:String,
        schemaVersion:Int,
        actions:[Dictionary<String, AnyObject>],
        predicate:Predicate,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        _postNewTrigger(
            TriggeredCommandForm(
                schemaName: schemaName,
                schemaVersion: schemaVersion,
                actions: actions),
            predicate: predicate,
            completionHandler: completionHandler);
    }
    
    /** Post new Trigger to IoT Cloud.
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter schemaName: Name of the Schema of which the Command specified in
     Trigger is defined.
     - Parameter schemaVersion: Version of the Schema of which the Command
     specified in Trigger is defined.
     - Parameter serverCode: Server code to be executed by the Trigger.
     - Parameter predicate: Predicate of the Command.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is an created Trigger instance, 2nd one is an ThingIFError instance when failed.
     */
    open func postNewTrigger(
        _ serverCode:ServerCode,
        predicate:Predicate,
        options:TriggerOptions? = nil,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        _postNewTrigger(
          serverCode,
          predicate: predicate,
          options: options,
          completionHandler: completionHandler)
    }


    /** Get specified trigger

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to obtain.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: an instance of Trigger, an instance of ThingIFError when failed.
    */
    open func getTrigger(
        _ triggerID:String,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        _getTrigger(triggerID, completionHandler: completionHandler)
    }

    /** Apply patch to a registered Trigger
    Modify a registered Trigger with the specified patch.

    **Note**: Please onboard first, or provide a target instance by
      calling copyWithTarget. Otherwise,
      KiiCloudError.TARGET_NOT_AVAILABLE will be return in
      completionHandler callback

    `target` property and `TriggeredCommandForm.targetID` must be same
    owner's things.

    - Parameter triggerID: ID of the Trigger to which the patch is applied.
    - Parameter triggeredCommandForm: Modified triggered command form
      to patch trigger.
    - Parameter predicate: Modified Predicate to be applied as patch.
    - Parameter options: Modified optional data for this trigger.
    - Parameter completionHandler: A closure to be executed once
      finished. The closure takes 2 arguments: 1st one is the modified
      Trigger instance, 2nd one is an ThingIFError instance when
      failed.
    */
    open func patchTrigger(
        _ triggerID:String,
        triggeredCommandForm:TriggeredCommandForm? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: (Trigger?, ThingIFError?) -> Void)
    {
        _patchTrigger(
            triggerID,
            triggeredCommandForm: triggeredCommandForm,
            predicate: predicate,
            options: options,
            completionHandler: completionHandler)
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
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the modified Trigger instance, 2nd one is an ThingIFError instance when failed.
    */
    open func patchTrigger(
        _ triggerID:String,
        schemaName:String?,
        schemaVersion:Int?,
        actions:[Dictionary<String, AnyObject>]?,
        predicate:Predicate?,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        let triggeredCommandForm: TriggeredCommandForm?
        if (schemaName != nil && schemaVersion != nil && actions != nil) {
            triggeredCommandForm = TriggeredCommandForm(
                schemaName: schemaName!,
                schemaVersion: schemaVersion!,
                actions: actions!)
        } else {
            triggeredCommandForm = nil
        }
        _patchTrigger(
            triggerID,
            triggeredCommandForm: triggeredCommandForm,
            predicate: predicate,
            completionHandler: completionHandler)
    }
    
    /** Apply patch to a registered Trigger
     Modify a registered Trigger with the specified patch.
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter triggerID: ID of the Trigger to which the patch is applied.
     - Parameter serverCode: Modified ServerCode to be applied as patch.
     - Parameter predicate: Modified Predicate to be applied as patch.
     - Parameter options: Optional data for this trigger.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the modified Trigger instance, 2nd one is an ThingIFError instance when failed.
     */
    open func patchTrigger(
        _ triggerID:String,
        serverCode:ServerCode? = nil,
        predicate:Predicate? = nil,
        options:TriggerOptions? = nil,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        _patchTrigger(triggerID,
                      serverCode: serverCode,
                      predicate: predicate,
                      options: options,
                      completionHandler: completionHandler)
    }

    /** Enable/Disable a registered Trigger
    If its already enabled(/disabled), this method won't throw error and behave
    as succeeded.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be enabled/disabled.
    - Parameter enable: Flag indicate enable/disable Trigger.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the enabled/disabled Trigger instance, 2nd one is an ThingIFError instance when failed.
    */
    open func enableTrigger(
        _ triggerID:String,
        enable:Bool,
        completionHandler: (Trigger?, ThingIFError?)-> Void
        )
    {
        _enableTrigger(triggerID, enable: enable, completionHandler: completionHandler)
    }
    
    /** Delete a registered Trigger.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter triggerID: ID of the Trigger to be deleted.
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 2 arguments: 1st one is the deleted TriggerId, 2nd one is an ThingIFError instance when failed.
    */
    open func deleteTrigger(
        _ triggerID:String,
        completionHandler: (String, ThingIFError?)-> Void
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
    - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Triggers instance if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
    */
    open func listTriggers(
        _ bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (_ triggers:[Trigger]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggers(bestEffortLimit, paginationKey: paginationKey, completionHandler: completionHandler)
    }
    
    /** Retrieves list of server code results that was executed by the specified trigger.
        Results will be listing with order by modified date descending (latest first)
     
     **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback
     
     - Parameter bestEffortLimit: Limit the maximum number of the Results in the
     Response. If omitted default limit internally defined is applied.
     Meaning of 'bestEffort' is if specified value is greater than default limit,
     default limit is applied.
     - Parameter triggerID: ID of the Trigger
     - Parameter paginationKey: If there is further page to be retrieved, this
     API returns paginationKey in 2nd element. Specifying this value in next
     call in the argument results continue to get the results from the next page.
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 3 arguments: 1st one is Array of Results instance if found, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of ThingIFError when failed.
     */
    open func listTriggeredServerCodeResults(
        _ triggerID:String,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: (_ results:[TriggeredServerCodeResult]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggeredServerCodeResults(triggerID, bestEffortLimit:bestEffortLimit, paginationKey:paginationKey, completionHandler: completionHandler)
    }


    // MARK: - Get the state of specified target

    /** Get the state of specified target.

    **Note**: Please onboard first, or provide a target instance by calling copyWithTarget. Otherwise, KiiCloudError.TARGET_NOT_AVAILABLE will be return in completionHandler callback

    - Parameter completionHandler: A closure to be executed once get state has finished. The closure takes 2 arguments: 1st one is Dictionary that represent Target State and 2nd one is an instance of ThingIFError when failed.
    */
    open func getState(
        _ completionHandler: (Dictionary<String, AnyObject>?,  ThingIFError?)-> Void
        )
    {
        _getState(completionHandler)
        
    }

    /** Get the Vendor Thing ID of specified Target.
     
     - Parameter completionHandler: A closure to be executed once get id has finished. The closure takes 2 arguments: 1st one is Vendor Thing ID and 2nd one is an instance of ThingIFError when failed.
     */
    open func getVendorThingID(
        _ completionHandler: @escaping (String?, ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(nil, ThingIFError.target_NOT_AVAILABLE)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)"
        ]

        // do request
        let request = buildDefaultRequest(
            HTTPMethod.GET,
            urlString: requestURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            completionHandler: { (response, error) -> Void in
                let vendorThingID = response?["_vendorThingID"] as? String
                DispatchQueue.main.async {
                    completionHandler(vendorThingID, error)
                }
            }
        )
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
    }

    /** Update the Vendor Thing ID of specified Target.

     - Parameter newVendorThingID: New vendor thing id
     - Parameter newPassword: New password
     - Parameter completionHandler: A closure to be executed once finished. The closure takes 1 argument: an instance of ThingIFError when failed.
     */
    open func updateVendorThingID(
        _ newVendorThingID: String,
        newPassword: String,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        if self.target == nil {
            completionHandler(ThingIFError.target_NOT_AVAILABLE)
            return;
        }
        if newVendorThingID.isEmpty || newPassword.isEmpty {
            completionHandler(ThingIFError.unsupported_ERROR)
            return;
        }

        let requestURL = "\(self.baseURL)/api/apps/\(self.appID)/things/\(self.target!.typedID.id)/vendor-thing-id"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = [
            "x-kii-appid": self.appID,
            "x-kii-appkey": self.appKey,
            "authorization": "Bearer \(self.owner.accessToken)",
            "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
        ]

        // genrate body
        let requestBodyDict = NSMutableDictionary(dictionary:
            [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
            ]
        )

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBodyDict, options: JSONSerialization.WritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(
                HTTPMethod.PUT,
                urlString: requestURL,
                requestHeaderDict: requestHeaderDict,
                requestBodyData: requestBodyData,
                completionHandler: { (response, error) -> Void in
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            )
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
        } catch(_) {
            kiiSevereLog("ThingIFError.JSON_PARSE_ERROR")
            completionHandler(ThingIFError.json_PARSE_ERROR)
        }
    }

    // MARK: - Copy with new target instance

    /** Get new instance with new target

    - Parameter newTarget: target instance will be setted to new ThingIFAPI instance
    - Parameter tag: tag of the ThingIFAPI instance or nil for default tag
    - Returns: New ThingIFAPI instance with newTarget
    */
    open func copyWithTarget(_ newTarget: Target, tag : String? = nil) -> ThingIFAPI {

        let newIotapi = ThingIFAPI(app: self.app, owner: self.owner, tag: tag)

        newIotapi._target = newTarget
        newIotapi._installationID = self._installationID
        newIotapi.saveToUserDefault()
        return newIotapi
    }

    /** Try to load the instance of ThingIFAPI using stored serialized instance.

    - Parameter tag: tag of the ThingIFAPI instance
    - Returns: ThingIFAPI instance.
    */
    open static func loadWithStoredInstance(_ tag : String? = nil) throws -> ThingIFAPI?{
        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE
        let key = ThingIFAPI.getSharedNSDefaultKey(tag)

        // try to get iotAPI from NSUserDefaults

        if let dict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary
        {
            if dict.object(forKey: key) != nil {
                if let data = dict[key] as? Data {
                    if let savedIoTAPI = NSKeyedUnarchiver.unarchiveObject(with: data) as? ThingIFAPI {
                        return savedIoTAPI
                    }else{
                        throw ThingIFError.invalid_STORED_API
                    }
                }else{
                    throw ThingIFError.invalid_STORED_API
                }
            } else {
                throw ThingIFError.api_NOT_STORED
            }
        }else{
            throw ThingIFError.api_NOT_STORED
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
        let key = ThingIFAPI.getSharedNSDefaultKey(tag)
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict.removeObject(forKey: key)
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }
    }

    func saveToUserDefault(){

        let baseKey = ThingIFAPI.SHARED_NSUSERDEFAULT_KEY_INSTANCE

        let key = ThingIFAPI.getSharedNSDefaultKey(self.tag)
        let data = NSKeyedArchiver.archivedData(withRootObject: self)

        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[key] = data
            UserDefaults.standard.set(dict, forKey: baseKey)
        }else{
            UserDefaults.standard.set(NSDictionary(dictionary: [key:data]), forKey: baseKey)
        }
        UserDefaults.standard.synchronize()
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let anAPI = object as? ThingIFAPI else{
            return false
        }

        return self.appID == anAPI.appID &&
            self.appKey == anAPI.appKey &&
            self.baseURL == anAPI.baseURL &&
            self.target?.accessToken == anAPI.target?.accessToken &&
            self.target?.typedID == anAPI.target?.typedID &&
            self.installationID == anAPI.installationID &&
            self.tag == anAPI.tag
    }

    
}
