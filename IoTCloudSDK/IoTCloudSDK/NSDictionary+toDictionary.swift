//
//  NSDictionary+toDictionary.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
extension NSDictionary {

    public func toDictionary() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        for (key, value) in self {
            if value is String {
                dict[key as! String] = value as! String
            } else if value is NSDictionary {
                if let valueDict = value as? NSDictionary {
                    dict[key as! String] = valueDict.toDictionary()
                }
            }else if value is NSNumber {
                if let numberValue = value as? NSNumber {
                    if numberValue.isBool() {
                        dict[key as! String] = numberValue.boolValue
                    }else {
                        dict[key as! String] = numberValue.integerValue
                    }
                }
            }
        }
        return dict
    }
}