//
//  ThingIFError.swift
//  ThingIFSDK
//
import Foundation
import Swift

/** Represents ErrorResponse from IoT Cloud */
public struct ErrorResponse {
    public let httpStatusCode: Int
    public let errorCode: String
    public let errorMessage: String

    init (httpStatusCode:Int, errorCode:String, errorMessage:String) {
        self.httpStatusCode = httpStatusCode
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

public enum ThingIFError : Error {
    case connection
    case error_RESPONSE(required: ErrorResponse)
    case push_NOT_AVAILABLE
    case json_PARSE_ERROR
    case unsupported_ERROR
    /** when already onboarded */
    case already_ONBOARDED
    /** where target not found */
    case target_NOT_AVAILABLE
    /** when trying to load API from persistance but not avaialble*/
    case api_NOT_STORED
    /** when trying to load API from persistance but it does not have correct instance*/
    case invalid_STORED_API
    /** when trying to access Gateway but user is not logged in*/
    case user_IS_NOT_LOGGED_IN
    /** whenever request operation is failed. (i.e invalid URL) */
    case error_REQUEST(required: NSError)
}
