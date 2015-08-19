//
//  Logger.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation


public enum LogLevel: Int {
    case verbose  = 100
    case debug  = 200
    case info   = 300
    case warn   = 400
    case error  = 500
    case severe = 600
    public func caption() -> String{
        switch self {
        case .verbose : return "VERBOSE : "
        case .debug : return "DEBUG : "
        case .info : return "INFO : "
        case .warn : return "WARN : "
        case .error : return "ERROR : "
        case .severe : return "SEVERE : "
        }
    }
}

public protocol Logger {
    func printLog<T>(level : LogLevel,value: T)
}

var logLevel : LogLevel = LogLevel.error

public func setKiiLogLevel(level : LogLevel){
    logLevel = level
}

extension Logger {
    public func printLog<T>(level : LogLevel,value: T){

        if logLevel.rawValue > level.rawValue{
            return
        }

        print(level.caption(),value)
    }


}

//default logger is just default implementation for logger
public class DefaultLogger : Logger {

    required  public init() {

    }

    
}
// use as dependency injection
var currentLogger = DefaultLogger.self

let sharedLog: Logger = {
    let instance = currentLogger.init()

    return instance
    }()

public func kiiVerboseLog<T>(value: T){
    sharedLog.printLog(.verbose, value: value)
}

public func kiiDebugLog<T>(value: T){
    sharedLog.printLog(.debug, value: value)
}

public func kiiInfoLog<T>(value: T){
    sharedLog.printLog(.info, value: value)
}

public func kiiWarnLog<T>(value: T){
    sharedLog.printLog(.warn, value: value)
}

public func kiiErrorLog<T>(value: T){
    sharedLog.printLog(.error, value: value)
}
public func kiiSevereLog<T>(value: T){
    sharedLog.printLog(.severe, value: value)
}