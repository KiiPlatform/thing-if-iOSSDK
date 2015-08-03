//
//  Schema.swift
//  IoTCloudSDK
//
import Foundation

/// Class represents Schema.
public class Schema: NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement it.
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        self.thingType = ""
        self.name = ""
        self.version = 0
    }

    /// Type of the Thing to which the Schema bounds
    public let thingType: String
    /// Name of the Schema.
    public let name: String
    /// Version of the Schema.
    public let version: Int
    /// Initizlize Schema with thingTye, name and version.
    public init(thingType: String, name: String, version: Int) {
        self.thingType = thingType
        self.name = name
        self.version = version
    }
}