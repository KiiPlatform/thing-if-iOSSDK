//
//  App.swift
//  ThingIFSDK
//
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

/** Represents Kii Cloud Application */
open class App: NSObject, NSCoding {
    /** ID of the App */
    open let appID: String
    /** Key of the APP */
    open let appKey: String
    /** Host name to which the app connects */
    open let hostName: String
    /** Base URL of the apis used by the app */
    open let baseURL: String
    /** Name of the site to which the app belongs */
    open let siteName: String

    // MARK: NSCoding
    /** Conforms to NSCoding */
    public required convenience init(coder decoder:NSCoder) {
        let appID:String = decoder.decodeObject(forKey: "appID") as! String
        let appKey:String = decoder.decodeObject(forKey: "appKey") as! String
        let hostName:String = decoder.decodeObject(forKey: "hostName") as! String
        let baseURL:String = decoder.decodeObject(forKey: "baseURL") as! String
        let siteName:String = decoder.decodeObject(forKey: "siteName") as! String
        self.init(appID:appID, appKey:appKey, hostName:hostName,
            baseURL:baseURL, siteName:siteName)
    }

    /** Conforms to NSCoding */
    open func encode(with coder: NSCoder) {
        coder.encode(self.appID, forKey:"appID")
        coder.encode(self.appKey, forKey:"appKey")
        coder.encode(self.hostName, forKey:"hostName")
        coder.encode(self.baseURL, forKey:"baseURL")
        coder.encode(self.siteName, forKey:"siteName")
    }

    // MARK: Initializers
    /** Init app with appID, appKey and site.
     If you haven't created application in Kii Cloud,
     Please vist https://developer.kii.com and create your app first.

     - Parameter appID: ID of the app.
     - Parameter appKey: Key of the app.
     - Parameter site: Location of the app.
    */
    public init(appID:String, appKey:String, site:Site) {
        self.appID = appID
        self.appKey = appKey
        self.hostName = site.getHostName()
        self.baseURL = site.getBaseUrl()
        self.siteName = site.getName()
    }

    fileprivate init(appID:String, appKey:String, hostName:String,
        baseURL:String, siteName:String)
    {
        self.appID = appID
        self.appKey = appKey
        self.hostName = hostName
        self.baseURL = baseURL
        self.siteName = siteName
    }

    /** Init app with appID, appKey, hostName, baseURL, siteName and port.

     - Parameter appID: ID of the app.
     - Parameter appKey: Key of the app.
     - Parameter hostNabuildme: Host name to which the app connects
     - Parameter urlSchema: URL schema. By default, "https" is
       used. You can override the URL schema with this parameter.
     - Parameter siteName: Site name. By default site name is set to
       "CUSTOM". This site name should match with your Gateway Agent
       configuration if you interact Gateway Agent with this SDK.
     - Parameter port: port number.
    */
    public convenience init(
      appID: String,
      appKey: String,
      hostName: String,
      urlSchema: String = "https",
      siteName: String = "CUSTOM",
      port: Int32 = -1)
    {
        var baseURL:String = urlSchema + "://" + hostName
        if (port > 0) {
            baseURL = baseURL + ":" + String(port)
        }
        self.init(appID: appID, appKey: appKey,
             hostName: hostName, baseURL: baseURL, siteName: siteName)
    }

}
