//
//  Dictionary+toNSDictionary.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public func toNSDictionary() -> NSDictionary {
        let nsdict = NSMutableDictionary()
        for(key, value) in self {
            if value is Dictionary {
                nsdict[key as! String] = (value as! Dictionary).toNSDictionary()
            }else if value is Int{
                nsdict[key as! String] = NSNumber(integer: (value as! Int))
            }else if value is Bool {
                nsdict[key as! String] = NSNumber(bool: (value as! Bool))
            }else if value is Double {
                nsdict[key as! String] = NSNumber(double: (value as! Double))
            }else if value is Float {
                nsdict[key as! String] = NSNumber(float: (value as! Float))
            }else if value is String {
                nsdict[key as! String] = value as! String
            }
        }
        return nsdict
    }
}