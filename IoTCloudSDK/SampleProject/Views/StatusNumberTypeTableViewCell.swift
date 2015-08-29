//
//  StatusNumberTypeTableViewCell.swift
//  SampleProject
//
//  Created by Yongping on 8/29/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit

protocol StatusNumberTypeTableViewCellDelegate {
    func changeStatusNumberType(value: AnyObject)
}
class StatusNumberTypeTableViewCell: UITableViewCell {

    var delegate: StatusNumberTypeTableViewCellDelegate?
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusNameLabel: UILabel!
    
    @IBAction func changeValue(sender: AnyObject) {

    }

}

