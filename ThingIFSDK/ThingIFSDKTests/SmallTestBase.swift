import XCTest
@testable import ThingIFSDK

class SmallTestBase: XCTestCase {
    override func setUp() {
        super.setUp()
        MockSession.mockResponse = (data: nil, urlResponse: nil, error: nil)
        MockSession.requestVerifier = {(request) in }
        MockMultipleSession.responsePairs = [MockResponsePair?]()
        ThingIFAPI.removeAllStoredInstances()
    }
}