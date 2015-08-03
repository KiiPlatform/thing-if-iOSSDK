//
//  IoTCloudError.swift
//  IoTCloudSDK
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

public enum IoTCloudError : ErrorType {
    case CONNECTION
    case ERROR_RESPONSE(required: ErrorResponse)
}