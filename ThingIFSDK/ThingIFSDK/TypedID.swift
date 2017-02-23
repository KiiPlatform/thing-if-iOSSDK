//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
open class TypedID : NSObject, NSCoding {

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
    public required convenience init(coder aDecoder: NSCoder) {
        self.init(
          Types(rawValue: aDecoder.decodeObject(forKey: "type") as! String)!,
          id: aDecoder.decodeObject(forKey: "id") as! String)
    }

    /** Type of the ID*/
    open let type:Types
    /** ID of the entity. */
    open let id:String

    /** Hash value for `TypedID` instance. */
    open override var hashValue: Int {
        get {
            return self.toString().hashValue
        }
    }

    /** hash value override `NSObject.hash`.

     This value is same as 'TypedID.hashValue'.
     */
    open override var hash: Int {
        get {
            return self.hashValue
        }
    }

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity.
    - Parameter id: ID of the entity.
     */
    public init(_ type:Types, id:String) {
        self.type = type
        self.id = id
    }

    internal func toString() -> String {
        return "\(type):\(id)"
    }

    /** Check whether object equals to this instance or not.

     - Parameter object: object to be checked.
     - Returns: true if object equals to this instance otherwise false.
     */
    open override func isEqual(_ object: Any?) -> Bool {
        guard let aType = object as? TypedID else{
            return false
        }
        return self.id == aType.id && self.type == aType.type
    }

}
