//
//  Owner.swift
//  ThingIFSDK
//

import Foundation

/** Represents Owner */
public class Owner: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.typedID, forKey: "typedID")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObjectForKey("typedID") as! TypedID
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String
    }

    /** ID of the owner. */
    public let typedID: TypedID
    /** Access token of the owner. */
    public let accessToken: String

    /** instantiate Owner.

    - Parameter typedID: ID of the Owner.
    - Parameter accessToken: Access Token of the Owner.
     */
    public init(typedID: TypedID, accessToken: String) {
        self.typedID = typedID
        self.accessToken = accessToken
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let anOwner = object as? Owner else{
            return false
        }
        
        return self.typedID == anOwner.typedID && self.accessToken == anOwner.accessToken
        
    }
}
