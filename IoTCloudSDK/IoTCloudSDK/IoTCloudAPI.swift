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
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an target, an IoTCloudError
    */
    public func onBoard(
        vendorThingID:String,
        thingPassword:String,
        thingType:String?,
        thingProperties:NSDictionary?,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) throws ->Void
    {
        try _onBoard(true, IDString: vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { (target, error) -> Void in
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
        ) throws ->Void
    {
        try _onBoard(false, IDString: thingID, thingPassword: thingPassword, thingType: nil, thingProperties: nil) { (target, error) -> Void in
            completionHandler(target, error)
        }
    }
    
    private func _onBoard(
        byVendorThingID: Bool,
        IDString: String,
        thingPassword:String,
        thingType:String?,
        thingProperties:NSDictionary?,
        completionHandler: (Target?, IoTCloudError?)-> Void
        ) throws ->Void {
            
            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/onboardings"
            
            // genrate body
            let requestBodyDict = NSMutableDictionary(dictionary: ["thingPassword": thingPassword, "owner": owner.ownerID.toString()])
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
            
            if byVendorThingID {
                requestBodyDict.setObject(IDString, forKey: "vendorThingID")
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            }else {
                requestBodyDict.setObject(IDString, forKey: "thingID")
                requestHeaderDict["Content-type"] = "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            }
            
            if thingType != nil {
                requestBodyDict.setObject(thingType!, forKey: "thingType")
            }
            
            if thingProperties != nil {
                requestBodyDict.setObject(thingProperties!, forKey: "thingProperties")
            }
            
            do{
                let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                // do request
                let request = IotRequest(method:.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in

                    var target:Target?
                    if let thingID = response?["thingID"] as? String{
                        target = Target(targetType: TypedID(type: "THING", id: thingID))
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(target, error)
                    }
                })
                let onboardRequestOperation = IoTRequestOperation(request: request)
                operationQueue.addOperation(onboardRequestOperation)
                
            }catch(let e){
                throw e
            }
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
    
    /** Install push notification to receive notification from IoT Cloud.
    IoT Cloud will send notification when the Target replies to the Command.
    Application can receive the notification and check the result of Command
    fired by Application or registered Trigger.
    After installation is done Installation ID is managed in this class.
    - Parameter development: flag indicate whether the cert is development or
    production.
    - Returns: installationID published by IoT Cloud.
    - Throws: IoTCloudError when push notifications is not enabled, failed to connect to internet or IoT Cloud
    Server returns error.
    */
    public func installPush(
        development:Bool = false,
        completionHandler: (String?, IoTCloudError?)-> Void
        ) throws -> Void
    {
        func doInstallationRequest() -> Void {
            let requestURL = "\(baseURL)/iot-api/apps/\(appID)/installations"
            
            // genrate body
            let requestBodyDict = NSMutableDictionary()
            
            // generate header
            var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "appID": appID]
            
            requestHeaderDict["Content-type"] = "application/vnd.kii.InstallationCreationRequest+json"
            
            do{
                let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                // do request
                let request = IotRequest(method:.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                    // TODO: generate target from response
                    
                    if let installationID = response?["thingID"] as? String{
                        self._installationID = installationID
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(self._installationID, error)
                    }
                })
                let onboardRequestOperation = IoTRequestOperation(request: request)
                operationQueue.addOperation(onboardRequestOperation)
                
            }catch(let e){
                print(e)
            }
        }
        
        let pushAvilabilityCondition = RemoteNotificationCondition(application: UIApplication.sharedApplication())
        let pushNotAvailableCondition = NegatedCondition<RemoteNotificationCondition>(condition: pushAvilabilityCondition)
        
        let errorPushNotAvailableOperation = BlockOperation { () -> Void in
            completionHandler(nil,IoTCloudError.PUSH_NOT_AVAILABLE)
        }
        
        errorPushNotAvailableOperation.addCondition(pushNotAvailableCondition)
        
        self.operationQueue.addOperation(errorPushNotAvailableOperation)
        
        let installPushOperation = BlockOperation { () -> Void in
            doInstallationRequest()
            
        }
        
        installPushOperation.addCondition(pushAvilabilityCondition)
        
        self.operationQueue.addOperation(installPushOperation)
        //TODO: finish implementations
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
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed to connect to internet or IoT Cloud Server returns error.
    */
    public func postNewCommand(
        target:Target,
        schemaName:String,
        schemaVersion:Int,
        actions:[NSDictionary],
        issuer:TypedID?,
        completionHandler: (Command?, IoTCloudError?)-> Void
        ) throws -> Void
    {
        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target.targetType.toString())/commands"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        // generate body
        let requestBodyDict = NSMutableDictionary(dictionary: ["schema": schemaName, "schemaVersion": schemaVersion])
        requestBodyDict.setObject(actions, forKey: "actions")

        var issuerID: TypedID!
        if issuer == nil {
            issuerID = owner.ownerID
        }else {
            issuerID = issuer
        }
        requestBodyDict.setObject(issuerID.toString(), forKey: "issuer")

        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = IotRequest(method:.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                var command:Command?
                if let commandID = response?["commandID"] as? String{
                    var actionsArray = [Dictionary<String, Any>]()
                    for nsdict in actions {
                        var actionsDict = Dictionary<String, Any>()
                        for(key, value) in nsdict {
                            actionsDict[key as! String] = value
                        }
                        actionsArray.append(actionsDict)
                    }
                    command = Command(commandID: commandID, targetID: target.targetType, issuerID: issuerID, schemaName: schemaName, schemaVersion: schemaVersion, actions: actionsArray, actionResults: nil, commandState: nil)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(command, error)
                }
            })
            let onboardRequestOperation = IoTRequestOperation(request: request)
            operationQueue.addOperation(onboardRequestOperation)

        }catch(let e){
            throw e
        }
    }
    
    /** Get specified command
    
    - Parameter target: Target of the Command.
    - Parameter commandID: ID of the Command to obtain.
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 2 arguments: an instance of created command, an instance of IoTCloudError when failed to connect to internet or IoT Cloud Server returns error.
     */
    public func getCommand(
        target:Target,
        commandID:String,
        completionHandler: (Command?, IoTCloudError?)-> Void
        ) throws -> Void
    {
        let requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target.targetType.toString())/commands/\(commandID)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = IotRequest(method:HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in

            var command:Command?
            if let responseDict = response{
                command = Command.commandWithNSDictionary(responseDict)
            }
            completionHandler(command, error)
        })

        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
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
    - Parameter completionHandler: A closure to be executed once on board has finished. The closure takes 3 arguments: 1st one is an instance of created command, 2nd one is paginationKey if there is further page to be retrieved, and 3rd one is an instance of IoTCloudError when failed to connect to internet or IoT Cloud Server returns error.
     */
    public func listCommands(
        target:Target,
        bestEffortLimit:Int?,
        paginationKey:String?,
        completionHandler: ([Command]?, String?, IoTCloudError?)-> Void
        ) throws -> Void
    {
        var requestURL = "\(baseURL)/iot-api/apps/\(appID)/targets/\(target.targetType.toString())/commands"
        if paginationKey != nil && bestEffortLimit != nil{
            requestURL += "?paginationKey=\(paginationKey!)&&bestEffortLimit=\(bestEffortLimit!)"
        }else if bestEffortLimit != nil {
            requestURL += "?bestEffortLimit=\(bestEffortLimit!)"
        }

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)", "content-type": "application/json"]

        let request = IotRequest(method:HTTPMethod.GET,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            var commands = [Command]()
            var nextPaginationKey: String?
            if response != nil {
                if let commandNSDicts = response!["commands"] as? [NSDictionary] {
                    for commandNSDict in commandNSDicts {
                        if let command = Command.commandWithNSDictionary(commandNSDict) {
                            commands.append(command)
                        }
                    }
                }
                nextPaginationKey = response!["nextPaginationKey"] as? String
            }
            completionHandler(commands, nextPaginationKey, error)
        })

        let onboardRequestOperation = IoTRequestOperation(request: request)
        operationQueue.addOperation(onboardRequestOperation)
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