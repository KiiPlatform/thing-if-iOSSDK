//
//  NSData+Operations.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/12/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

public extension Data {
    func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count), count:self.count)
        // Array of hex strings, one for each byte:
        let hexBytes = bytes.map{ String(format: "%02hhx", $0) }
        // Concatenate all hex strings:

        return hexBytes.joined(separator: "")
    }
}
