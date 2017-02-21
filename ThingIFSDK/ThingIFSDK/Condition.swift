//
//  Condition.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright 2016 Kii. All rights reserved.
//

import Foundation
/** Class represents Condition */
open class Condition : NSObject, NSCoding {
    open let clause: TriggerClause

    /** Init Condition with Clause

     - Parameter clause: Clause instance
     */
    public init(_ clause: TriggerClause) {
        self.clause = clause
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! TriggerClause);
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clause)
    }

}
