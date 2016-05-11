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
/** Represents error in validation process */
public struct ValidationError {
    public let errorCode: String // error category
    public let errorMessage: String // short description
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
    /** when passing invalid object/parameter*/
    case VALIDATION_ERROR(error : ValidationError)

}
