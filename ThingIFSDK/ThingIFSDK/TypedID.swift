//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
open class TypedID : Equatable, NSCoding {

    public enum Types: String {
        /** User type. */
        case user = "user"
        /** Group type. */
        case group = "group"
        /** Thing type. */
        case thing = "thing"

    }

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.id, forKey: "id")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.type = Types(rawValue: aDecoder.decodeObject(forKey: "type") as! String)!
        self.id = aDecoder.decodeObject(forKey: "id") as! String
    }

    /** Type of the ID*/
    open let type:Types
    /** ID of the entity. */
    open let id:String

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity.
    - Parameter id: ID of the entity.
     */
    public init(_ type:Types, id:String) {
        self.type = type
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
