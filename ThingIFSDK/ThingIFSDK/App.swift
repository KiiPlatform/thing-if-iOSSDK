//
//  App.swift
//  ThingIFSDK
//
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

/** Represents Kii Cloud Application */
public class App: NSObject, NSCoding {
    /** ID of the App */
    public let appID: String
    /** Key of the APP */
    public let appKey: String
    /** Host name to which the app connects */
    public let hostName: String
    /** Base URL of the apis used by the app */
    public let baseURL: String
    /** Name of the site to which the app belongs */
    public let siteName: String

    // MARK: NSCoding
    /** Conforms to NSCoding */
    public required convenience init(coder decoder:NSCoder) {
        let appID:String = decoder.decodeObjectForKey("appID") as! String
        let appKey:String = decoder.decodeObjectForKey("appKey") as! String
        let hostName:String = decoder.decodeObjectForKey("hostName") as! String
        let baseURL:String = decoder.decodeObjectForKey("baseURL") as! String
        let siteName:String = decoder.decodeObjectForKey("siteName") as! String
        self.init(appID:appID, appKey:appKey, hostName:hostName,
            baseURL:baseURL, siteName:siteName)
    }

    /** Conforms to NSCoding */
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.appID, forKey:"appID")
        coder.encodeObject(self.appKey, forKey:"appKey")
        coder.encodeObject(self.hostName, forKey:"hostName")
        coder.encodeObject(self.baseURL, forKey:"baseURL")
        coder.encodeObject(self.siteName, forKey:"siteName")
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

/** App Builder provides fine grained controll over createing App instance.
 Private/ Dedicated Kii Cloud users will use it.
 Public Kii Cloud user who uses apps created on
 https://developer.kii.com does not need to interact with this Builder.
 Just use App(appID:appKey:site) constructor is fine.
*/
public class AppBuilder: NSObject {
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
    public func setPort(port:Int32) -> AppBuilder {
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
    public func setUrlSchema(urlSchema:String) -> AppBuilder {
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
    public func setSiteName(siteName:String) -> AppBuilder {
        self.siteName = siteName
        return self
    }

    /** Build App instance

     - Returns: App instance
    */
    public func build() -> App {
        var baseURL:String = urlSchema + "://" + hostName
        if (self.port > 0) {
            baseURL = baseURL + ":" + String(port)
        }
        return App(appID: self.appID, appKey: self.appKey,
            hostName: self.hostName, baseURL: baseURL, siteName: self.siteName)
    }

}