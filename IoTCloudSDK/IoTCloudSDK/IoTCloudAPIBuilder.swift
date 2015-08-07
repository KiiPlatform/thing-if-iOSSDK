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
    - Parameter baseURL: URL of the Site.
    - Parameter owner: Owner who consumes IoTCloudAPI.
     */
    public init(appID: String, appKey: String, baseURL: String, owner: Owner) {

        iotCloudAPI = IoTCloudAPI()
        iotCloudAPI.appID = appID
        iotCloudAPI.appKey = appKey
        iotCloudAPI.baseURL = baseURL
        iotCloudAPI.owner = owner
    }

    /** Add schema to the builder. Multiple Schema can be added.
    - Parameter schema: Schema to be added.
    - Returns: IoTCloudAPIBuilder instance for chaining.
    */
    public func addSchema(schema:Schema) -> IoTCloudAPIBuilder {
        // TODO: implement it.
        return self
    }

    /** Build IoTCloudAPI instance.
    - Returns: IoTCloudAPI instance.
     */
    public func build() -> IoTCloudAPI {
        return iotCloudAPI
    }
}