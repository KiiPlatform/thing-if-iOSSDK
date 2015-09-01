//
//  Owner.swift
//  IoTCloudSDK
//

import Foundation

/** Represents Owner */
public class Owner: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.ownerID, forKey: "ownerID")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.ownerID = aDecoder.decodeObjectForKey("ownerID") as! TypedID
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String
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
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let anOwner = object as? Owner else{
            return false
        }
        
        return self.ownerID == anOwner.ownerID && self.accessToken == anOwner.accessToken
        
    }
}
