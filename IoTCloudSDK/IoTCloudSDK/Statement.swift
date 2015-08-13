//
//  Statement.swift
//  IoTCloudSDK
//
import Foundation

/** Protocole of the Statement must be conformed to. */
public protocol Statement {
    func toJSONObject() -> NSDictionary
}

/** Class represents Equals statement. */
public class Equals: Statement {
    var nsdict = NSMutableDictionary()

    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
     */
    public init(field:String, value:String) {
       nsdict.setObject(value, forKey: field)
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        nsdict.setObject(NSNumber(integer: value), forKey: field)
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        nsdict.setObject(NSNumber(bool: value), forKey: field)
    }
    /** Serialize Statement into JSON Object
    - Returns: JSON Object NSDictionary.
    */
    public func toJSONObject() -> NSDictionary {
        return NSDictionary(dictionary: ["=":nsdict])
    }
}

// TODO: implement other statements.