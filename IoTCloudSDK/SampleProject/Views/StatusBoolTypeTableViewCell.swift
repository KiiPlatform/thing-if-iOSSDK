//
//  StatusBoolTypeTableViewCell.swift
//  SampleProject
//
//  Created by Yongping on 8/29/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit

class StatusBoolTypeTableViewCell: UITableViewCell {

    var delegate: StatusTableViewCellDelegate?

    var value: Bool? {
        didSet {
            if value != nil {
                if value != boolSwitch.on {
                    boolSwitch.on = value!
                }
            }
        }
    }

    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusNameLabel: UILabel!

    @IBAction func changeSwitch(sender: AnyObject) {
        let boolSwitch = sender as! UISwitch
        value = boolSwitch.on
        delegate?.setStatus(self, value: boolSwitch.on)
    }
}
