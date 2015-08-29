//
//  StatusBoolTypeTableViewCell.swift
//  SampleProject
//
//  Created by Yongping on 8/29/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit

protocol StatusBoolTypeTableViewCellDelegate {
    func changeStatusBoolType(value: Bool)
}
class StatusBoolTypeTableViewCell: UITableViewCell {

    var delegate: StatusBoolTypeTableViewCellDelegate?

    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusNameLabel: UILabel!

    @IBAction func changeSwitch(sender: AnyObject) {
        if delegate != nil {
            delegate!.changeStatusBoolType(self.boolSwitch.on)
        }
    }
}
