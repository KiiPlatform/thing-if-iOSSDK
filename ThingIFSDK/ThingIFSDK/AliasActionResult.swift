//
//  AliasActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of action for an alias. */
open class AliasActionResult: NSCoding {

    /** Name of an alias. */
    open let alias: String
    /** Results of actions for an alias. */
    open let results: [ActionResult]

    internal init(_ alias: String, results: [ActionResult]) {
        self.alias = alias
        self.results = results
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        let alias = aDecoder.decodeObject(forKey: "alias") as! String
        let count = aDecoder.decodeInteger(forKey: "count")
        var results: [ActionResult] = []
        for i in 0..<count {
            let data = aDecoder.decodeObject(forKey: String(i))
            let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as! Data);
            let result = ActionResult(coder: decoder)!
            decoder.finishDecoding()
            results.append(result)
        }
        self.init(alias, results: results)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alias, forKey: "alias")
        aCoder.encode(self.results.count, forKey: "count")
        for i in 0..<self.results.count {
            let data = NSMutableData(capacity: 1024)!
            let coder = NSKeyedArchiver(forWritingWith: data)
            self.results[i].encode(with: coder)
            coder.finishEncoding()
            aCoder.encode(data, forKey: String(i))
        }
    }
}
