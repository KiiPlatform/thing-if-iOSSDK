//
//  Dictionarable.swift
//  ThingIFSDK
//
//  Created on 2017/03/03.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal protocol JsonSerializable {

    func makeJson() -> [String : Any]

}
