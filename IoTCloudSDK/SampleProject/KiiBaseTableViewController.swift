//
//  KiiBaseTableViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/25/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class KiiBaseTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var iotAPI: IoTCloudAPI?
    var target: Target?
    var schema: IoTSchema?

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

        if schema == nil {
            if let schemaData = NSUserDefaults.standardUserDefaults().objectForKey("schema") as? NSData {
                if let schema = NSKeyedUnarchiver.unarchiveObjectWithData(schemaData) as? IoTSchema {
                    self.schema = schema
                }
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

    func getStatusFromClause(clause: Clause) -> String {
        let clauseDict = clause.toNSDictionary()
        let clauseType = ClauseType.getClauseType(clause)!

        if clauseType != ClauseType.NotEquals {
            return clauseDict["field"] as! String
        }else {
            return (clauseDict["clause"] as! Dictionary<String, AnyObject>)["field"] as! String
        }
    }
}
