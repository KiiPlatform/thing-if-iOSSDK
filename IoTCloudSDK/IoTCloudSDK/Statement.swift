//
//  Statement.swift
//  IoTCloudSDK
//
import Foundation

/** Protocole of the Statement must be conformed to. */
public protocol Statement {
    func toJSONObject() -> NSString
}

/** Class represents Equals statement. */
public class Equals: Statement {

    /** Initialize with String left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
     */
    public init(field:String, value:String) {
        // TODO: implement it.
    }

    /** Initialize with Int left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Int) {
        // TODO: implement it.
    }

    /** Initialize with Bool left hand side value.
    - Parameter field: Name of the field to be compared.
    - Parameter value: Left hand side value to be compared.
    */
    public init(field:String, value:Bool) {
        // TODO: implement it.
    }
    /** Serialize Statement into JSON Object
    - Returns: JSON Object String.
    */
    public func toJSONObject() -> NSString {
        // TODO: implement it.
        return ""
    }

}

// TODO: implement other statements.