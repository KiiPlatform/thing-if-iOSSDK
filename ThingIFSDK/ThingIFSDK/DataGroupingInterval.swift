//
//  DataGroupingInterval.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public enum DataGroupingInterval {
    case INTERVAL_1_MINUTE
    case INTERVAL_15_MINUTES
    case INTERVAL_30_MINUTES
    case INTERVAL_1_HOUR
    case INTERVAL_12_HOURS

    public func getInterval() -> String {
        switch self {
        case .INTERVAL_1_MINUTE:
            return "1_MINUTE"
        case .INTERVAL_15_MINUTES:
            return "15_MINUTES"
        case .INTERVAL_30_MINUTES:
            return "30_MINUTES"
        case .INTERVAL_1_HOUR:
            return "1_HOUR"
        case .INTERVAL_12_HOURS:
            return "12_HOURS"
        }
    }
}
