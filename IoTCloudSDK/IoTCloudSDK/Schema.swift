//
//  Schema.swift
//  IoTCloudSDK
//
import Foundation

/// Class represents Schema.
public class Schema {
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