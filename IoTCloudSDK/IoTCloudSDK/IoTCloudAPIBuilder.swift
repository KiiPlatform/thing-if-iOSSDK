//
//  IoTCloudAPIBuilder.swift
//  IoTCloudSDK
//

import Foundation

/** Builder class of IoTCloudAPI */
public class IoTCloudAPIBuilder {

    /** Initialize builder.
    - Parameter appID: ID of the application published by Kii Cloud.
    - Parameter appKey: Key of the application published by Kii Cloud.
    - Parameter baseURL: URL of the Site.
    - Parameter owner: Owner who consumes IoTCloudAPI.
     */
    public init(appID: String, appKey: String, baseURL: String, owner: Owner) {
        // TODO: implement it.
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
        // TODO: implement it.
        return IoTCloudAPI()
    }
}