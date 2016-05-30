//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
public class TypedID : NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.type, forKey: "type")
        aCoder.encodeObject(self.id, forKey: "id")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.type =
            (aDecoder.decodeObjectForKey("type") as! String).lowercaseString
        self.id = aDecoder.decodeObjectForKey("id") as! String
    }

    /** Type of the ID

     All characters in this string are lower case.
     */
    public let type:String
    /** ID of the entity. */
    public let id:String

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity. All upper case characters in
      given string are converted to lower case.
    - Parameter id: ID of the entity.
     */
    public init(type:String, id:String) {
        self.type = type.lowercaseString
        self.id = id
    }

    func toString() -> String {
        return "\(type):\(id)"
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aType = object as? TypedID else{
            return false
        }
        return (self.type == aType.type) && (self.id == aType.id)
    }
}
