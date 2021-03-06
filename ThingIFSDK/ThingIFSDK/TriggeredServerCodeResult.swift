import Foundation

/** Class represents result of server code trigged by trigger */
public struct TriggeredServerCodeResult {

    /** Whether the invocation succeeded */
    public let succeeded: Bool
    /** Date of the execution */
    public let executedAt: Date
    /** The endpoint used in the server code invocation */
    public let endpoint: String?
    /** Error object of the invocation if any */
    public let error: ServerError?

    /** Returned value from server code (JsonObject, JsonArray, String, Number, Boolean or null) */
    public let returnedValue: Any?

    /** Returned value from server code casted to String. */
    public var returnedValueAsString: String? {
        get {
            if let str = self.returnedValue as? String {
                return str
            } else if let num = self.returnedValue as? NSNumber {
                return String(describing: num)
            }
            return nil
        }
    }

    /** Returned value from server code casted to Bool. */
    public var returnedValueAsBool: Bool? {
        get {
            return self.returnedValue as? Bool
        }
    }

    /** Returned value from server code casted to Int. */
    public var returnedValueAsInt: Int? {
        get {
            return self.returnedValue as? Int
        }
    }

    /** Returned value from server code casted to Double. */
    public var returnedValueAsDouble: Double? {
        get {
            return self.returnedValue as? Double
        }
    }

    /** Returned value from server code casted to [String : Any]. */
    public var returnedValueAsDictionary: Dictionary<String, Any>? {
        get {
            return self.returnedValue as? Dictionary<String, Any>
        }
    }

    /** Returned value from server code casted to [Any]. */
    public var returnedValueAsArray: [Any]? {
        get {
            return self.returnedValue as? [Any]
        }
    }

    /** Initialize `TriggeredServerCodeResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameter succeeded: Whether the invocation succeeded
     - Parameter executedAt: Date of the execution
     - Parameter endpoint: The endpoint used in the server code invocation
     - Parameter returnedValue: Returned value from server code
     - Parameter error: Error object of the invocation if any
     */
    public init(
      _ succeeded: Bool,
      executedAt: Date,
      endpoint: String?,
      returnedValue: Any? = nil,
      error: ServerError? = nil)
    {
        self.succeeded = succeeded
        self.executedAt = executedAt
        self.returnedValue = returnedValue
        self.endpoint = endpoint
        self.error = error
    }

}

extension TriggeredServerCodeResult: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        guard let succeeded = jsonObject["succeeded"] as? Bool,
              let executedAt = jsonObject["executedAt"] as? Int64 else {
            throw ThingIFError.jsonParseError
        }

        let serverError: ServerError?
        if let error = jsonObject["error"] as? [String : Any] {
            serverError = try ServerError(error)
        } else {
            serverError = nil
        }

        self.init(
          succeeded,
          executedAt: Date(timeIntervalSince1970InMillis: executedAt),
          endpoint: jsonObject["endpoint"] as? String,
          returnedValue: jsonObject["returnedValue"],
          error: serverError)
    }
}

public struct ServerError {

    /** Error message. */
    public let errorMessage: String?
    /** Error code. */
    public let errorCode: String?
    /** Detail message. */
    public let detailMessage: String?

    /** Initialize `ServerError`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameter errorMessage: Error message.
     - Parameter errorCode: Error can.
     - Parameter detailMessage: Detail message.
     */
    public init(
      _ errorMessage: String? = nil,
      errorCode: String? = nil,
      detailMessage: String? = nil)
    {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.detailMessage = detailMessage
    }

}

extension ServerError: FromJsonObject {
    internal init(_ jsonObject: [String : Any]) throws {
        let details = jsonObject["details"] as? [String : Any]
        self.init(
          jsonObject["errorMessage"] as? String,
          errorCode: details?["errorCode"] as? String,
          detailMessage: details?["message"] as? String)
    }
}
