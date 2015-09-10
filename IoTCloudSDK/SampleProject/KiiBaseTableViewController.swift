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
        do{
            try iotAPI = IoTCloudAPI.loadWithStoredInstance()
            self.navigationItem.title = iotAPI?.target?.targetType.id
        }catch(_){
            // do nothing
        }
        target = iotAPI?.target
        self.navigationController?.navigationItem.title = target?.targetType.id

        if schema == nil {
            if let schemaData = NSUserDefaults.standardUserDefaults().objectForKey("schema") as? NSData {
                if let schema = NSKeyedUnarchiver.unarchiveObjectWithData(schemaData) as? IoTSchema {
                    self.schema = schema
                }
            }
        }

        showActivityView(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            default:
                break
            }
        }
        showAlert(title, message: errorString, completion: completion)
    }

    func logout(completion: ()-> Void) {
        IoTCloudAPI.removeStoredInstances()
        completion()
    }

}
