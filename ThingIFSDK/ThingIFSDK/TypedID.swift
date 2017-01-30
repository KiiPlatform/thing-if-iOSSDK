//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
open class TypedID : Equatable, NSCoding {

    public enum Types: String {
        /** User type. */
        case use = "user"
        /** Group type. */
        case group = "group"
        /** Thing type. */
        case thing = "thing"

    }

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.*/")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.*/")
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
