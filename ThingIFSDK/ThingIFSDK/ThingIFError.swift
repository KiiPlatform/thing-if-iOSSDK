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
    case errorResponse(required: ErrorResponse)
    case pushNotAvailable
    case jsonParseError
    case unsupportedError
    /** when already onboarded */
    case alreadyOnboarded
    /** where target not found */
    case targetNotAvailable
    /** when trying to load API from persistance but not avaialble*/
    case apiNotStored
    /** when trying to load API from persistance but it does not have correct instance*/
    case invalidStoredApi
    /** when trying to access Gateway but user is not logged in*/
    case userIsNotLoggedIn
    /** whenever request operation is failed. (i.e invalid URL) */
    case errorRequest(required: NSError)
}
