//
//  KiiApp.swift
//  ThingIFSDK
//
//  Copyright 2015 Kii. All rights reserved.
//

import Foundation

/** Represents Kii Cloud Application */
public struct KiiApp {
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

    // MARK: Initializers
    /** Init app with appID, appKey and site.
     If you haven't created application in Kii Cloud,
     Please vist https://developer.kii.com and create your app first.

     - Parameter appID: ID of the app.
     - Parameter appKey: Key of the app.
     - Parameter site: Location of the app.
    */
    public init(_ appID:String, appKey:String, site:Site) {
        self.init(
          appID,
          appKey: appKey,
          hostName: site.getHostName(),
          baseURL: site.getBaseUrl(),
          siteName: site.getName())
    }

    private init(
      _ appID: String,
      appKey: String,
      hostName: String,
      baseURL: String,
      siteName: String)
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
    public init(
      _ appID: String,
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
        self.init(appID, appKey: appKey,
             hostName: hostName, baseURL: baseURL, siteName: siteName)
    }

}
