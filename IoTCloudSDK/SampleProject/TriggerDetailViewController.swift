//
//  TriggerDetailViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/26/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class TriggerDetailViewController: KiiBaseTableViewController {

    public var trigger: Trigger?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if trigger != nil {
            self.navigationItem.title = trigger!.triggerID
        }
        loadSections()
    }

    func loadSections() {

    }
}