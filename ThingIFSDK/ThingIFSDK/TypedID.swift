//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
open class TypedID : Equatable, NSCoding {

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.id, forKey: "id")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.type =
            (aDecoder.decodeObject(forKey: "type") as! String).lowercased()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
    }

    /** Type of the ID

     All characters in this string are lower case.
     */
    open let type:String
    /** ID of the entity. */
    open let id:String

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity. All upper case characters in
      given string are converted to lower case.
    - Parameter id: ID of the entity.
     */
    public init(type:String, id:String) {
        self.type = type.lowercased()
        self.id = id
    }

    func toString() -> String {
        return "\(type):\(id)"
    }

    open func isEqual(_ object: Any?) -> Bool {
        guard let aType = object as? TypedID else{
            return false
        }
        return (self.type == aType.type) && (self.id == aType.id)
    }

    public static func == (left: TypedID, right: TypedID) -> Bool {
        return left.isEqual(right)
    }
}
