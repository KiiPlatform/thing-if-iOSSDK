import XCTest
@testable import ThingIFSDK

class SmallTestBase: XCTestCase {
    override func setUp() {
        super.setUp()
        sharedMockSession.mockResponse = (data: nil, urlResponse: nil, error: nil)
        sharedMockSession.requestVerifier = {(request) in }
        sharedMockMultipleSession.responsePairs = [MockResponsePair?]()
        ThingIFAPI.removeAllStoredInstances()
    }
}