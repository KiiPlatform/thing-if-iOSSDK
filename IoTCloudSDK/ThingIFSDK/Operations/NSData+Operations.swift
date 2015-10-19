//
//  NSData+Operations.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/12/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

public extension NSData {
    func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        // Array of hex strings, one for each byte:
        let hexBytes = bytes.map{ String(format: "%02hhx", $0) }
        // Concatenate all hex strings:

        return hexBytes.joinWithSeparator("")
    }
}