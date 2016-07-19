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

public enum ThingIFError : ErrorType {
    case CONNECTION
    case ERROR_RESPONSE(required: ErrorResponse)
    case PUSH_NOT_AVAILABLE
    case JSON_PARSE_ERROR
    case UNSUPPORTED_ERROR
    /** when already onboarded */
    case ALREADY_ONBOARDED
    /** where target not found */
    case TARGET_NOT_AVAILABLE
    /** when trying to load API from persistance but not avaialble*/
    case API_NOT_STORED
    /** when trying to load API from persistance but it does not have correct instance*/
    case INVALID_STORED_API
    /** when trying to access Gateway but user is not logged in*/
    case USER_IS_NOT_LOGGED_IN
    /** whenever request operation is failed. (i.e invalid URL) */
    case ERROR_REQUEST(required: NSError)
}
