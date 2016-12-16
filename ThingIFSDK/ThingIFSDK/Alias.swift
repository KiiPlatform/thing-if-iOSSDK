//
//  Alias.swift
//  ThingIFSDK
//
//  Created on 2016/12/14.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/**
 A protocol representing alias.
 */
public protocol Alias: NSCoding {

    func makeDictionary() -> [String : Any]

}

/**
 A class representing trait alias.
 */
open class TraitAlias: NSObject, Alias {

    /**
     Name of trait alias.
     */
    open let name: String

    /**
     Initializer for `TraitAlias`.

     - Parameter name: Name of trait alias.
     */
    public init(_ name: String) {
        self.name = name
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! String)
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name)
    }

    open func makeDictionary() -> [String : Any] {
        return [ "alias" : self.name ]
    }
}

/**
 A class representing no trait alias.

 There is no alias for non trait actions. If you want to non trait
 version of thing if SDK, You need to use `NonTraitAlias` instead of
 `TraitAlias`.
 */
open class NonTraitAlias: NSObject, Alias {

    public required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }

    open func encode(with aCoder: NSCoder) {
    }

    open func makeDictionary() -> [String : Any] {
        return [ : ]
    }
}
