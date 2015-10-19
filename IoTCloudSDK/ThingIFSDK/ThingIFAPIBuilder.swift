//
//  ThingIFAPIBuilder.swift
//  IoTCloudSDK
//

import Foundation

/** Builder class of ThingIFAPI */
public class ThingIFAPIBuilder {

    var iotCloudAPI: ThingIFAPI!

    /** Initialize builder.
    - Parameter appID: ID of the application published by Kii Cloud.
    - Parameter appKey: Key of the application published by Kii Cloud.
    - Parameter site: One of enum Site.
    - Parameter owner: Owner who consumes ThingIFAPI.
    - Parameter tag: tag of the ThingIFAPI instance.
     */
    public init(appID: String, appKey: String, site: Site, owner: Owner,tag: String? = nil) {

        iotCloudAPI = ThingIFAPI(baseURL: site.getBaseUrl(), appID: appID, appKey: appKey, owner: owner, tag: tag)
    }

    /** Build ThingIFAPI instance.
    - Returns: ThingIFAPI instance.
     */
    public func build() -> ThingIFAPI {
        return iotCloudAPI
    }
}