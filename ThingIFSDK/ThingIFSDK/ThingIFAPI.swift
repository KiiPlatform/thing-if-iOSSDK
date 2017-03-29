//
//  ThingIFAPI.swift
//  ThingIFSDK
//

import Foundation

/** Class provides API of the ThingIF. */
open class ThingIFAPI: Equatable {

    /** Tag of the ThingIFAPI instance */
    open let tag : String?

    internal let operationQueue = OperationQueue()
    /** URL of KiiApps Server */
    open var baseURL: String {
        get {
            return self.app.baseURL
        }
    }
    /** The application ID found in your Kii developer console */
    open var appID: String {
        get {
            return self.app.appID
        }
    }
    /** The application key found in your Kii developer console */
    open var appKey: String {
        get {
            return self.app.appKey
        }
    }
    /** Kii Cloud Application */
    open let app: KiiApp
    /** owner of target */
    open let owner: Owner

    /** Get installationID if the push is already installed.
    null will be returned if the push installation has not been done.

    - Returns: Installation ID used in IoT Cloud.
    */
    open internal(set) var installationID: String?

    /** target */
    open internal(set) var target: Target?

    /** Checks whether on boarding is done. */
    open var onboarded: Bool {
        get {
            return self.target != nil
        }
    }

    /** Initialize `ThingIFAPI` instance.

     - Parameter app: Kii Cloud Application.
     - Parameter owner: Owner who consumes ThingIFAPI.
     - Parameter target: target of the ThingIFAPI instance.
     - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(
      _ app: KiiApp,
      owner: Owner,
      target: Target? = nil,
      tag : String? = nil)
    {
        self.app = app
        self.owner = owner
        self.target = target
        self.tag = tag
    }
    
    /** Uninstall push notification.
    After done, notification from IoT Cloud won't be notified.

    - Parameter installationID: installation ID returned from installPush().
    If null is specified, value of the installationID property is used.
    */
    open func uninstallPush(
        _ installationID:String?,
        completionHandler: @escaping (ThingIFError?)-> Void
        )
    {
        _uninstallPush(installationID, completionHandler: completionHandler)
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
        completionHandler: @escaping (Trigger?, ThingIFError?)-> Void
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
        completionHandler: @escaping (String, ThingIFError?)-> Void
        )
    {
        _deleteTrigger(triggerID, completionHandler: completionHandler)
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
        bestEffortLimit:Int? = nil,
        paginationKey:String? = nil,
        completionHandler: @escaping (_ results:[TriggeredServerCodeResult]?, _ paginationKey:String?, _ error: ThingIFError?)-> Void
        )
    {
        _listTriggeredServerCodeResults(triggerID, bestEffortLimit:bestEffortLimit, paginationKey:paginationKey, completionHandler: completionHandler)
    }

    // MARK: Qeury state history.

    /** Query history states with trait alias.

     - Parameter query: Instance of `HistoryStatesQuery`. If nil or
       omitted, query all history states
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 3 arguments:
       - 1st one is array of history states. If there is no objects to
         be queried, the array is empty.
       - 2nd one is a pagination key. It represents information to
         retrieve further page. You can use pagination key to retrieve
         next page by setting nextPaginationKey. if there is no
         further page, pagination key is nil.
       - 3rd one is an instance of ThingIFError when failed.
     */
    open func query(
      _ query: HistoryStatesQuery? = nil,
      completionHandler: @escaping (
        [HistoryState]?, String?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    /** Group history state

     - Parameter query: `GroupedHistoryStatesQuery` instance.timeRange
       in query should less than 60 data grouping intervals.
     - Parameter completionHandler: A closure to be executed once
       finished. The closure takes 2 arguments:
       - 1st one is `GroupedHistoryStates` array.
       - 2nd one is an instance of ThingIFError when failed.
     */
    open func query(
      _ query: GroupedHistoryStatesQuery,
      completionHandler: @escaping (
        [GroupedHistoryStates]?, ThingIFError?) -> Void) -> Void
    {
        // TODO: implement me.
    }

    // MARK: - Copy with new target instance

    /** Get new instance with new target

    - Parameter newTarget: target instance will be setted to new ThingIFAPI instance
    - Parameter tag: tag of the ThingIFAPI instance or nil for default tag
    - Returns: New ThingIFAPI instance with newTarget
    */
    open func copyWithTarget(_ newTarget: Target, tag : String? = nil) -> ThingIFAPI {

        let newIotapi = ThingIFAPI(self.app,
                                   owner: self.owner,
                                   target: newTarget,
                                   tag: tag)

        newIotapi.installationID = self.installationID
        newIotapi.saveToUserDefault()
        return newIotapi
    }

    public static func == (left: ThingIFAPI, right: ThingIFAPI) -> Bool {
        return left.appID == right.appID &&
          left.appKey == right.appKey &&
          left.baseURL == right.baseURL &&
          left.target?.accessToken == right.target?.accessToken &&
          left.target?.typedID == right.target?.typedID &&
          left.installationID == right.installationID &&
          left.tag == right.tag
    }

}

internal extension ThingIFAPI {

    var defaultHeader: [String : String] {
        get {
            return [
              "Authorization" : "Bearer \(self.owner.accessToken)",
              "X-Kii-AppID" : self.appID,
              "X-Kii-AppKey" : self.appKey,
              "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
            ]
        }
    }
}
