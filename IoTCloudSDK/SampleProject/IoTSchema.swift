//
//  IoTSchema.swift
//  SampleProject
//
//  Created by Yongping on 8/28/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import Foundation
import IoTCloudSDK

enum StatusType: String{
    case BoolType = "boolean"
    case IntType = "integer"
    case DoubleType = "double"
    case StringType = "string"

    init?(string: String) {
        switch string {
        case StatusType.BoolType.rawValue:
            self = .BoolType
        case StatusType.IntType.rawValue:
            self = .IntType
        case StatusType.DoubleType.rawValue:
            self = .DoubleType
        case StatusType.StringType.rawValue:
            self = .StringType
        default:
            return nil
        }
    }
}

struct ActionStruct {
    let actionSchema: ActionSchema!
    var value: AnyObject!

    // the return Ditionary will be like: ["actionName": ["requiredStatus": value] ], where value can be Bool, Int or Double. ie. ["TurnPower": ["power": true]]
    func getActionDict() -> Dictionary<String, AnyObject> {
        let actionDict: Dictionary<String, AnyObject> = [actionSchema.name: [actionSchema.status.name: value]]
        return actionDict
    }

    init(actionSchema: ActionSchema, value: AnyObject) {
        self.actionSchema = actionSchema
        self.value = value
    }

    init?(actionSchema: ActionSchema, actionDict: Dictionary<String, AnyObject>) {
        self.actionSchema = actionSchema

        if actionDict.keys.count == 0 {
            return nil
        }

        let actionNameKey = Array(actionDict.keys)[0]

        if actionSchema.name == actionNameKey {
            if let statusDict = actionDict[actionNameKey] as? Dictionary<String, AnyObject> {
                let statusNameKey = Array(statusDict.keys)[0]
                if actionSchema.status.name == statusNameKey {
                    self.value = statusDict[statusNameKey]
                }else{
                    return nil
                }
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
}


class StatusSchema: NSObject, NSCoding {
    let name: String!
    let type: StatusType!
    var minValue: AnyObject?
    var maxValue: AnyObject?

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        aCoder.encodeObject(self.minValue, forKey: "minValue")
        aCoder.encodeObject(self.maxValue, forKey: "maxValue")
    }

    // MARK: - Implements NSCoding protocol
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.type = StatusType(string: aDecoder.decodeObjectForKey("type") as! String)!
        self.minValue = aDecoder.decodeObjectForKey("minValue")
        self.maxValue = aDecoder.decodeObjectForKey("maxValue")
    }

    init(name: String, type: StatusType, minValue: AnyObject?, maxValue: AnyObject?) {
        self.name = name
        self.type = type
        self.minValue = minValue
        self.maxValue = maxValue
    }

}

class ActionSchema: NSObject, NSCoding {
    let name: String!
    let status: StatusSchema!

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.status, forKey: "status")
    }

    // MARK: - Implements NSCoding protocol
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.status = aDecoder.decodeObjectForKey("status") as! StatusSchema
    }

    init(actionName: String, status: StatusSchema) {
        self.name = actionName
        self.status = status
    }

}

class IoTSchema: NSObject,NSCoding {
    let name: String!
    let version: Int!

    private var statusSchemaDict = Dictionary<String, StatusSchema>()
    private var actionSchemaDict = Dictionary<String, ActionSchema>()
    

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.version, forKey: "version")
        aCoder.encodeObject(self.statusSchemaDict, forKey: "statusSchemaDict")
        aCoder.encodeObject(self.actionSchemaDict, forKey: "actionSchemaDict")
    }

    // MARK: - Implements NSCoding protocol
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.version = aDecoder.decodeObjectForKey("version") as! Int
        self.statusSchemaDict = aDecoder.decodeObjectForKey("statusSchemaDict") as! Dictionary<String, StatusSchema>
        self.actionSchemaDict = aDecoder.decodeObjectForKey("actionSchemaDict") as! Dictionary<String, ActionSchema>
    }

    init(name: String, version: Int) {
        self.name = name
        self.version = version
    }


    func addStatus(statusName: String, statusType: StatusType) {
        statusSchemaDict[statusName] = StatusSchema(name: statusName, type: statusType, minValue: nil, maxValue: nil)
    }

    func addStatus(statusName: String, statusType: StatusType, minValue: AnyObject?, maxvalue: AnyObject?) {
        statusSchemaDict[statusName] = StatusSchema(name: statusName, type: statusType, minValue: minValue, maxValue: maxvalue)
    }

    func getStatusType(status: String) -> StatusType? {
        return statusSchemaDict[status]?.type
    }

    func getStatusSchema(status: String) -> StatusSchema? {
        return statusSchemaDict[status]
    }

    func addAction(actionName: String, statusName: String) -> Bool {
        if let statusSchema = getStatusSchema(statusName) {
            actionSchemaDict[actionName] = ActionSchema(actionName: actionName, status: statusSchema)
            return true
        }else {
            return false
        }
    }

    func getActionSchema(actionName: String) -> ActionSchema? {
        return actionSchemaDict[actionName]
    }

    func getActionNames() -> [String] {
        return Array(actionSchemaDict.keys)
    }

    func getStatusNames() -> [String] {
        return Array(statusSchemaDict.keys)
    }

}