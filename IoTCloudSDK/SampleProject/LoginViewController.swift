//
//  LoginViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/24/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//
import UIKit
import IoTCloudSDK

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var userLogined = false

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userLogined = false
        self.showActivityView(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapLogin(sender: AnyObject) {

        self.showActivityView(true)

        if let userName = userNameTextField.text, password = passwordTextField.text {
            KiiUser.authenticate(userName, withPassword: password, andBlock: { (user, error) -> Void in
                if error == nil {
                    if let userID = user.userID, accessToken = user.accessToken {
                        let owner = Owner(ownerID: TypedID(type: "user", id: userID), accessToken: accessToken)
                        self.showActivityView(false)
                        print(owner.ownerID.toString())
                        self.userLogined = true
                        self.performSegueWithIdentifier("userLogin", sender: nil)
                    }
                }else {
                    print(error)
                    self.showAlert("Login Failed", message: error.description, completion: { (action) -> Void in
                        self.showActivityView(false)
                    })
                }
            })
        }else {
            // show alert
            print("please input username and password")
        }
    }
    @IBAction func tapRegister(sender: AnyObject) {

        self.showActivityView(true)

        if let userName = userNameTextField.text, password = passwordTextField.text {
            let newUser = KiiUser(username: userName, andPassword: password)
            newUser.performRegistrationWithBlock({ (user, error) -> Void in
                if error == nil {
                    if let userID = user.userID, accessToken = user.accessToken {
                        let owner = Owner(ownerID: TypedID(type: "user", id: userID), accessToken: accessToken)
                        print(owner.ownerID.toString())
                        self.userLogined = true
                        self.performSegueWithIdentifier("userRegister", sender: nil)
                    }
                }else {
                    print(error)
                    self.showAlert("Registerd Failed", message: error.description, completion: { (action) -> Void in
                        self.showActivityView(false)
                    })
                }

            })
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "userLogin" || identifier == "userRegister" {
            if self.userLogined {
                return true
            }else{
                return false
            }
        }else {
            return false
        }
    }

    func showActivityView(show: Bool) {
        if show && self.activityIndicatorView.hidden{
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimating()
        }else if !(show || self.activityIndicatorView.hidden) {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
        }
    }

    func showAlert(title: String, message: String, completion: (()-> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: completion)
    }
}
