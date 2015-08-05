//: Playground - noun: a place where people can play
import IoTCloudSDK

let owner = Owner(ownerID: TypedID(type:"user", id:"user-abcd-efgh"), accessToken: "dummy-token")
let schema = Schema(thingType: "SmartLight-Demo",
    name: "SmartLight-Demo", version: 1)
let api = IoTCloudAPIBuilder(appID: "myApp", appKey: "myAppKey",
    baseURL: "https://api.kii.com/", owner: owner).addSchema(schema).build()

let target = try api.onBoard("th.abcd-efgh", thingPassword: "dummyPassword")
print(target.description)
