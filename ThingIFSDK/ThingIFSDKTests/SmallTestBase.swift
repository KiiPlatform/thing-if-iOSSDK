import XCTest
@testable import ThingIFSDK

class SmallTestBase: XCTestCase {
    override func setUp() {
        super.setUp()
        sharedMockSession.mockResponse = (data: nil, urlResponse: nil, error: nil)
        sharedMockSession.requestVerifier = {(request) in }
        sharedMockMultipleSession.responsePairs = [MockResponsePair]()
        ThingIFAPI.removeAllStoredInstances()
    }

    internal func setMockResponse4Onboard(
      _ accessToken: String,
      thingID: String,
      setting:TestSetting) throws -> Void
    {
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken": accessToken, "thingID": thingID],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string: setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self
    }

    private func setMockResponse4InstallPush(
      _ installationID: String,
      setting:TestSetting) throws -> Void
    {
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["installationID":installationID],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string: setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self
    }
}
