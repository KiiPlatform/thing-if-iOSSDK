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
}

/** App Builder provides fine grained controll over createing App instance.
 Private/ Dedicated Kii Cloud users will use it.
 Public Kii Cloud user who uses apps created on
 https://developer.kii.com does not need to interact with this Builder.
 Just use App(appID:appKey:site) constructor is fine.
*/
open class AppBuilder: NSObject {
    private let appID:String
    private let appKey:String
    private let hostName:String
    private var urlSchema:String
    private var siteName:String
    private var port:Int32

    /** Init the Builder.

     - Parameter appID: ID of the app.
     - Parameter appKey: Key of the app.
     - Parameter hostName: Host name to which the app connects
    */
    public init(appID:String, appKey:String, hostName:String) {
        self.appID = appID
        self.appKey = appKey
        self.hostName = hostName
        self.urlSchema = "https"
        self.siteName = "CUSTOM"
        self.port = -1
    }

    /** Set port number.
     This method call is optional.
     By default no port number is used to connect to the cloud.

     - Parameter port: port number. 0 or less than 0 would be ignored.
     - Returns: AppBuilder instance.
    */
    open func setPort(_ port:Int32) -> AppBuilder {
        self.port=port
        return self
    }

    /** Set the API endpoint URL schema
     This method call is optional.
     By default "https" is used. You can override the URL schema with this
     method.

     - Parameter urlSchema: API endpoit URL schema
     - Returns: AppBuilder instance.
    */
    open func setUrlSchema(_ urlSchema:String) -> AppBuilder {
        self.urlSchema = urlSchema
        return self
    }

    /** Set site name.
     This method call is optional.
     By default site name is set to "CUSTOM".
     This site name should match with your Gateway Agent configuration
     if you interact Gateway Agent with this SDK.

     - Parameter siteName: site name.
     - Returns: AppBuilder instance.
    */
    open func setSiteName(_ siteName:String) -> AppBuilder {
        self.siteName = siteName
        return self
    }

    /** Build App instance

     - Returns: App instance
    */
    open func build() -> App {
        var baseURL:String = urlSchema + "://" + hostName
        if (self.port > 0) {
            baseURL = baseURL + ":" + String(port)
        }
        return App(appID: self.appID, appKey: self.appKey,
            hostName: self.hostName, baseURL: baseURL, siteName: self.siteName)
    }

}
