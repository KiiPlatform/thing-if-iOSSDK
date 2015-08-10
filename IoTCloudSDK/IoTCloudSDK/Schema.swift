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
        aCoder.encodeObject(self.thingType, forKey: "thingType")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeInteger(self.version, forKey: "version")
        
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        self.thingType = aDecoder.decodeObjectForKey("thingType") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.version = aDecoder.decodeIntegerForKey("version")
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
    
    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aSchema = object as? Schema else{
            return false
        }
        
        return self.version == aSchema.version &&
            self.thingType == aSchema.thingType &&
            self.name == aSchema.name
    }
}