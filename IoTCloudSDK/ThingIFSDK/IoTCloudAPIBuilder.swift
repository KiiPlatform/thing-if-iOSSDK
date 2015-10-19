//
//  IoTCloudAPIBuilder.swift
//  IoTCloudSDK
//

import Foundation

/** Builder class of IoTCloudAPI */
public class IoTCloudAPIBuilder {

    var iotCloudAPI: IoTCloudAPI!

    /** Initialize builder.
    - Parameter appID: ID of the application published by Kii Cloud.
    - Parameter appKey: Key of the application published by Kii Cloud.
    - Parameter site: One of enum Site.
    - Parameter owner: Owner who consumes IoTCloudAPI.
    - Parameter tag: tag of the IoTCloudAPI instance.
     */
    public init(appID: String, appKey: String, site: Site, owner: Owner,tag: String? = nil) {

        iotCloudAPI = IoTCloudAPI(baseURL: site.getBaseUrl(), appID: appID, appKey: appKey, owner: owner, tag: tag)
    }

    /** Build IoTCloudAPI instance.
    - Returns: IoTCloudAPI instance.
     */
    public func build() -> IoTCloudAPI {
        return iotCloudAPI
    }
}