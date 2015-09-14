//
//  AppDelegate.swift
//  SampleProject
//
//  Created by Yongping on 8/5/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // init Kii with the values from Properties.plist, so please make sure to set the correct value
        var propertiesDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist") {
            propertiesDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = propertiesDict {
            Kii.beginWithID((dict["appID"] as! String), andKey: (dict["appKey"] as! String), andCustomURL: (dict["kiiCloudCustomURL"] as! String))
        }else {
            print("please make sure the Properties.plist file exists")
        }

        // define schema
        let smartLightDemoSchema = IoTSchema(name: "SmartLight-Demo", version: 1)
        smartLightDemoSchema.addStatus("power", statusType: StatusType.BoolType)
        smartLightDemoSchema.addStatus("brightness", statusType: StatusType.IntType, minValue: 0, maxvalue: 100)
        smartLightDemoSchema.addStatus("color", statusType: StatusType.IntType, minValue: 0, maxvalue: 16777215)
        smartLightDemoSchema.addAction("turnPower", statusName: "power")
        smartLightDemoSchema.addAction("setBrightness", statusName: "brightness")
        smartLightDemoSchema.addAction("setColor", statusName: "color")
        // save schema
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(smartLightDemoSchema), forKey: "schema")
        NSUserDefaults.standardUserDefaults().synchronize()

        //register for remote notification
        // this line does not ask for user permission
        application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //save device token in nsuserdefault

        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "deviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()

    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //TODO : implementations
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //TODO : implementations
    }

}

