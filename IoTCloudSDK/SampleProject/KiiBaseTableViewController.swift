//
//  KiiBaseTableViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

enum StatusType: String{
    case BoolType = "boolean"
    case IntType = "integer"
    case DoubleType = "double"
    case StringType = "string"

    init?(string: String) {
        switch string {
        case StatusType.BoolType.rawValue:
            self = .BoolType
        case StatusType.IntType.rawValue:
            self = .IntType
        case StatusType.DoubleType.rawValue:
            self = .DoubleType
        case StatusType.StringType.rawValue:
            self = .StringType
        default:
            return nil
        }
    }
}

class KiiBaseTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var iotAPI: IoTCloudAPI?
    var target: Target?
    var schemaDict: Dictionary<String, AnyObject>?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        showActivityView(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if iotAPI == nil {
            if let iotAPIData = NSUserDefaults.standardUserDefaults().objectForKey("iotAPI") as? NSData {
                if let iotAPI = NSKeyedUnarchiver.unarchiveObjectWithData(iotAPIData) as? IoTCloudAPI {
                    self.iotAPI = iotAPI
                }
            }
        }

        if target == nil {
            if let targetData = NSUserDefaults.standardUserDefaults().objectForKey("target") as? NSData {
                if let target = NSKeyedUnarchiver.unarchiveObjectWithData(targetData) as? Target {
                    self.target = target
                    self.navigationItem.title = target.targetType.id
                }
            }
        }

        if schemaDict == nil {
            if let schemaDict = NSUserDefaults.standardUserDefaults().objectForKey("schema") as? Dictionary<String, AnyObject> {
                self.schemaDict = schemaDict
            }
        }
    }

    func showActivityView(show: Bool) {
        if activityIndicatorView != nil {
            if show && self.activityIndicatorView.hidden{
                self.activityIndicatorView.hidden = false
                self.activityIndicatorView.startAnimating()
            }else if !(show || self.activityIndicatorView.hidden) {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.hidden = true
            }
        }
    }

    func showAlert(title: String, error: IoTCloudError?, completion: (() -> Void)?) {
        var errorString: String?
        if error != nil {
            switch error! {
            case .CONNECTION:
                errorString = "CONNECTION"
            case .ERROR_RESPONSE(let errorResponse):
                errorString = "{statusCode: \(errorResponse.httpStatusCode), errorCode: \(errorResponse.errorCode), message: \(errorResponse.errorMessage)}"
            case .JSON_PARSE_ERROR:
                errorString = "JSON_PARSE_ERROR"
            case .PUSH_NOT_AVAILABLE:
                errorString = "PUSH_NOT_AVAILABLE"
            case .UNSUPPORTED_ERROR:
                errorString = "UNSUPPORTED_ERROR"
            }
        }
        showAlert(title, message: errorString, completion: completion)
    }

    func logout(completion: ()-> Void) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("iotAPI")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("target")
        completion()
    }

    //MARK: methods for schema 
    func getRequireStatusSchema(status: String) -> Dictionary<String, AnyObject>? {
        if let specifySchema = schemaDict?["statusSchema"]?[status] as? Dictionary<String, AnyObject>{
            return specifySchema
        }else {
            return nil
        }
    }

    func getStatusArray() -> [String]? {
        var statusArray: [String]?
        if let statusSchemaDict = schemaDict?["statusSchema"] as? Dictionary<String, AnyObject>{
            if statusSchemaDict.keys.count > 0 {
                statusArray = Array(statusSchemaDict.keys)
            }
        }
        return statusArray
    }

    func getStatusType(status: String) -> StatusType? {
        var statusType: StatusType?

        if let statusSchemaDict = getRequireStatusSchema(status) {
            if let statusTypeString = statusSchemaDict["type"] as? String {
                statusType = StatusType(string: statusTypeString)
            }
        }
        return statusType
    }

    func getStatusFromClause(clause: Clause) -> String {
        let clauseDict = clause.toNSDictionary()
        let clauseType = ClauseType.getClauseType(clause)!

        if clauseType != ClauseType.NotEquals {
            return clauseDict["field"] as! String
        }else {
            return (clauseDict["clause"] as! Dictionary<String, AnyObject>)["field"] as! String
        }

    }

    func isBool(status: String) -> Bool? {
        if let statusSchemaDict = getRequireStatusSchema(status) {
            if let statusType = statusSchemaDict["type"] {
                if statusType as! String == "boolean" {
                    return true
                }else {
                    return false
                }
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    func isInt(status: String) -> Bool? {
        if let statusSchemaDict = getRequireStatusSchema(status) {
            if let statusType = statusSchemaDict["type"] {
                if statusType as! String == "integer" {
                    return true
                }else {
                    return false
                }
            }else {
                return nil
            }
        }else {
            return nil
        }
    }



}
