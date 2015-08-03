//
//  Owner.swift
//  IoTCloudSDK
//

import Foundation

/** Represents Owner */
public class Owner: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement it.
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        ownerID = TypedID(type: "", id: "")
        accessToken = ""
    }

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
