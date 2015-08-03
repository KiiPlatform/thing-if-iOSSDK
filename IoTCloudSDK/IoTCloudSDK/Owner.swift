//
//  Owner.swift
//  IoTCloudSDK
//

import Foundation

/** Represents Owner */
public class Owner {
    /** ID of the owner. */
    public let ownerID: TypedID
    /** Access token of the owner. */
    public let accessToken: String

    /** instantiate Owner.
    - Parameter ownerID: ID of the Owner.
    - Parameter accessToken: Access Token of the Owner.
     */
    public init(ownerID: TypedID, accessToken: String) {
        self.ownerID = ownerID
        self.accessToken = accessToken
    }
}
