//
//  NSCoderExtension.swift
//  ThingIFSDK
//
//  Created on 2017/02/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

extension NSCoder {

    internal func encodeNSCodingObject(
      _ object: NSCoding,
      forKey: String) -> Void
    {
        let data: NSMutableData = NSMutableData(capacity: 1024)!
        let coder: NSKeyedArchiver =
            NSKeyedArchiver(forWritingWith: data);
        object.encode(with: coder);
        coder.finishEncoding();
        self.encode(data, forKey: forKey)
    }

    internal func decodeNSCodingObject<T: NSCoding>(forKey: String) -> T! {
        guard let data = self.decodeObject(forKey: forKey) as? Data else {
            return nil
        }
        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data);
        let retval = T(coder: decoder)
        decoder.finishDecoding();
        return retval
    }

    internal func encodeNSCodingArray<T: NSCoding>(
      _ array: [T],
      forKey: String) -> Void
    {
        var dataArray: [NSMutableData] = []
        for object in array {
            let data: NSMutableData = NSMutableData(capacity: 1024)!
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            object.encode(with: coder);
            coder.finishEncoding();
            dataArray.append(data)
        }

        let wholeData: NSMutableData = NSMutableData(capacity: 1024)!
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: wholeData);
        coder.encode(dataArray.count, forKey: "count")
        for (index, data) in dataArray.enumerated() {
            coder.encode(data, forKey: "\(index)")
        }
        coder.finishEncoding();
        self.encode(wholeData, forKey: forKey)
    }

    internal func decodeNSCodingArray<T: NSCoding>(
      forKey: String) -> [T]?
    {
        guard let wholeData =
                self.decodeObject(forKey: forKey) as? Data else {
            return nil
        }

        var retval: [T] = []
        let wholeDecoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWith: wholeData);
        for index in 0..<wholeDecoder.decodeInteger(forKey: "count") {
            let data = wholeDecoder.decodeObject(forKey: "\(index)") as! Data
            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data);
            retval.append(T(coder: decoder)!)
            decoder.finishDecoding()

        }
        wholeDecoder.finishDecoding();
        return retval
    }
}
