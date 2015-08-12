//
//  IoTCloudSDKUsage.swift
//  IoTCloudSDKUsage
//

import XCTest
import IoTCloudSDK
//import PromiseKit
import Swift

class IoTCloudSDKUsage: XCTestCase {

    var api:IoTCloudAPI?
    override func setUp() {
        super.setUp()
        let owner = Owner(ownerID: TypedID(type:"user", id:"user-abcd-efgh"), accessToken: "dummy-token")
        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)
        api = IoTCloudAPIBuilder(appID: "myApp", appKey: "myAppKey",
            baseURL: "https://api.kii.com/", owner: owner).addSchema(schema).build()
    }

    override func tearDown() {
        super.tearDown()
    }

//    func onboardPromise(
//        thingID:String,
//        thingPassword:String
//        ) -> Promise<Target> {
//        let promise = Promise<Target>(resolvers: { fullfill, reject in
//            do {
//                let target = try api!.onBoard(thingID, thingPassword:thingPassword)
//                fullfill(target!)
//            } catch (let e) {
//                reject(e)
//            }
//        })
//        return promise
//    }
//
//    func postCommandPromise(target:Target) -> Promise<Command> {
//        let promise = Promise<Command>(resolvers:{ fulfill, reject in
//            do {
//                // There's bug.. can not handle literal well.. :\
//                // https://forums.developer.apple.com/thread/12254
//
//                let actions:[Dictionary<String,Any>] =
//                [
//                    ["turnPower" : ["power":true]],
//                    ["setBrightness" : ["bribhtness":90]],
//                    ["setColor" : ["color":[255,255, 0]]]
//                ]
//                let schemaName = "SmartLight-Demo"
//                let schemaVersion = 1
//                let command = try api!.postNewCommand(target,
//                    schemaName: schemaName, schemaVersion: schemaVersion,
//                    actions:actions, issuer: nil)
//                fulfill(command!)
//            } catch (let e) {
//                reject(e)
//            }
//        })
//        return promise
//    }
//
    func testExample() {
//        onboardPromise("th.abcd-efgh", thingPassword:"dummyPassword")
//            .then{(target:Target) throws -> Promise<Command> in
//                return self.postCommandPromise(target)
//            }.report { (error:(ErrorType)) -> Void in
//                // Handle error.
//            }
        }
//
}
