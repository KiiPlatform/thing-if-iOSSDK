//
//  Serializable.swift
//  ThingIFSDK
//
//  Created on 2017/03/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

private var typeMap: [ String : Serializable.Type] =
  [
    String(describing: ThingIFAPI.self) : ThingIFAPI.self,
    String(describing: KiiApp.self) : KiiApp.self,
    String(describing: Owner.self) : Owner.self,
    String(describing: TypedID.self) : TypedID.self,
    String(describing: StandaloneThing.self) : StandaloneThing.self,
    String(describing: Gateway.self) : Gateway.self,
    String(describing: EndNode.self) : EndNode.self,
  ]

internal struct Coder {

    private var dict: [String : Any] = [ : ]

    internal mutating func encode(
      _ value: String?,
      forKey key: String) -> Void
    {
        self.dict[key] = value
    }

    internal mutating func encode(
      _ value: Serializable?,
      forKey key: String) -> Void
    {
        guard let value2 = value else {
            return
        }

        var coder = Coder()
        value2.serialize(&coder)

        self.dict[key] = [
          "type" : String(describing: type(of: value2)),
          "value" : coder.finishCoding()
        ]
    }

    internal func finishCoding() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self.dict)
    }
}

internal struct Decoder {
    private let dict: [String : Any]

    internal init?(_ data: Data) {
        guard let dict = NSKeyedUnarchiver.unarchiveObject(
                with: data) as? [String : Any] else {
            return nil
        }
        self.dict = dict
    }

    internal func decodeString(forKey key: String) -> String? {
        return self.dict[key] as? String
    }

    internal func decodeSerializable(forKey key: String) -> Serializable? {
        guard let dict = self.dict[key] as? [String : Any] else {
            return nil
        }
        guard let type = typeMap[dict["type"] as! String] else {
            return nil
        }
        guard let decoer = Decoder(dict["value"] as! Data) else {
            return nil
        }
        return type.deserialize(decoer)
    }

    internal func finishDecoding() -> Void {
        fatalError()
    }
}

internal protocol Serializable {

    func serialize(_ coder: inout Coder) -> Void

    static func deserialize(_ decoder: Decoder) -> Serializable?
}
