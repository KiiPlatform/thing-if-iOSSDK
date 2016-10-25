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
    case us
    /** Use cloud in Japan. */
    case jp
    /** Use cloud in cn3 site of China. */
    case cn3
    /** Use cloud in Singapore. */
    case sg
    /** Use cloud in EU. */
    case eu

    /** Get base url of Site
    - Returns: Base URL string of Site.
    */
    public func getBaseUrl() -> String{
        switch self {
        case .us:
            return "https://api.kii.com"
        case .jp:
            return "https://api-jp.kii.com"
        case .cn3:
            return "https://api-cn3.kii.com"
        case .sg:
            return "https://api-sg.kii.com"
        case .eu:
            return "https://api-eu.kii.com"
        }
    }

    /** */
    public func getHostName() -> String {
        switch self {
        case .us:
            return "api.kii.com"
        case .jp:
            return "api-jp.kii.com"
        case .cn3:
            return "api-cn3.kii.com"
        case .sg:
            return "api-sg.kii.com"
        case .eu:
            return "api-eu.kii.com"
        }
    }

    public func getName() -> String {
        switch self {
        case .us:
            return "US"
        case .jp:
            return "JP"
        case .cn3:
            return "CN3"
        case .sg:
            return "SG"
        case .eu:
            return "EU"
        }
    }

}
