//
//  App.swift
//  ThingIFSDK
//
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

public class App: NSObject, NSCoding {
    public let appID: String
    public let appKey: String
    public let hostName: String
    public let baseURL: String
    public let siteName: String

    // MARK: NSCoding
    public required convenience init(coder decoder:NSCoder) {
        let appID:String = decoder.decodeObjectForKey("appID") as! String
        let appKey:String = decoder.decodeObjectForKey("appKey") as! String
        let hostName:String = decoder.decodeObjectForKey("hostName") as! String
        let baseURL:String = decoder.decodeObjectForKey("baseURL") as! String
        let siteName:String = decoder.decodeObjectForKey("siteName") as! String
        self.init(appID:appID, appKey:appKey, hostName:hostName,
            baseURL:baseURL, siteName:siteName)
    }

    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.appID, forKey:"appID")
        coder.encodeObject(self.appKey, forKey:"appKey")
        coder.encodeObject(self.hostName, forKey:"hostName")
        coder.encodeObject(self.baseURL, forKey:"baseURL")
        coder.encodeObject(self.siteName, forKey:"siteName")
    }

    public init(appID:String, appKey:String, site:Site) {
        self.appID = appID
        self.appKey = appKey
        self.hostName = site.getHostName()
        self.baseURL = site.getBaseUrl()
        self.siteName = site.getName()
    }

    private init(appID:String, appKey:String, hostName:String,
        baseURL:String, siteName:String)
    {
        self.appID = appID
        self.appKey = appKey
        self.hostName = hostName
        self.baseURL = baseURL
        self.siteName = siteName
    }
}

public class AppBuilder: NSObject {
    private let appID:String
    private let appKey:String
    private let hostName:String
    private var urlSchema:String
    private var siteName:String

    public init(appID:String, appKey:String, hostName:String) {
        self.appID = appID
        self.appKey = appKey
        self.hostName = hostName
        self.urlSchema = "https"
        self.siteName = "CUSTOM"
    }

    public func setUrlSchema(urlSchema:String) {
        self.urlSchema = urlSchema
    }

    public func setSiteName(siteName:String) {
        self.siteName = siteName
    }

    public func build() -> App {
        let baseURL:String = urlSchema + "://" + hostName
        return App(appID: self.appID, appKey: self.appKey,
            hostName: self.hostName, baseURL: baseURL, siteName: self.siteName)
    }

}