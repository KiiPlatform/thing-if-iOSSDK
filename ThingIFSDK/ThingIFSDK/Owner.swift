//
//  Owner.swift
//  ThingIFSDK
//

import Foundation

/** Represents Owner */
open class Owner: Equatable, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.typedID, forKey: "typedID")
        aCoder.encode(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObject(forKey: "typedID") as! TypedID
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String
    }

    /** ID of the owner. */
    open let typedID: TypedID
    /** Access token of the owner. */
    open let accessToken: String

    /** instantiate Owner.

    - Parameter typedID: ID of the Owner.
    - Parameter accessToken: Access Token of the Owner.
     */
    public init(_ typedID: TypedID, accessToken: String) {
        self.typedID = typedID
        self.accessToken = accessToken
    }
    
    open func isEqual(_ object: Any?) -> Bool {
        guard let anOwner = object as? Owner else{
            return false
        }
        
        return self.typedID == anOwner.typedID && self.accessToken == anOwner.accessToken
    }

    public static func == (left: Owner, right: Owner) -> Bool {
        return left.isEqual(right);
    }
}
