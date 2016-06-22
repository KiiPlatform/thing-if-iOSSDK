//
//  Site.swift
//  ThingIFSDK
//
//  Created by Yongping on 9/17/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

/**
* This enum represents KiiCloud server location.
*/
public enum Site {
    /** Use cloud in US. */
    case US
    /** Use cloud in Japan. */
    case JP
    /** Use cloud in cn3 site of China. */
    case CN3
    /** Use cloud in Singapore. */
    case SG
    /** Use cloud in EU. */
    case EU

    /** Get base url of Site
    - Returns: Base URL string of Site.
    */
    public func getBaseUrl() -> String{
        switch self {
        case .US:
            return "https://api.kii.com"
        case .JP:
            return "https://api-jp.kii.com"
        case .CN3:
            return "https://api-cn3.kii.com"
        case .SG:
            return "https://api-sg.kii.com"
        case .EU:
            return "https://api-eu.kii.com"
        }
    }

    /** */
    public func getHostName() -> String {
        switch self {
        case .US:
            return "api.kii.com"
        case .JP:
            return "api-jp.kii.com"
        case .CN3:
            return "api-cn3.kii.com"
        case .SG:
            return "api-sg.kii.com"
        case .EU:
            return "api-eu.kii.com"
        }
    }

    public func getName() -> String {
        switch self {
        case .US:
            return "US"
        case .JP:
            return "JP"
        case .CN3:
            return "CN3"
        case .SG:
            return "SG"
        case .EU:
            return "EU"
        }
    }

}