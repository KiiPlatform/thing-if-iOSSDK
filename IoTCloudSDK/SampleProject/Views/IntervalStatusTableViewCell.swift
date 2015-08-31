//
//  IntervalStatusTableViewCell.swift
//  SampleProject
//
//  Created by Yongping on 8/29/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit

protocol IntervalStatusCellDelegate {
    func setIntervalStatus(sender: UITableViewCell, lowerLimitValue: AnyObject, upperLimitValue: AnyObject)
}

class IntervalStatusIntTypeCell: UITableViewCell {
    var delegate: IntervalStatusCellDelegate?

    var minValue: Int? {
        didSet{
            if minValue != nil {
                lowerLimitValueSlider.minimumValue = Float(minValue!)
                upperLimitValueSlider.minimumValue = Float(minValue!)
            }
        }
    }
    var maxValue: Int?{
        didSet{
            if maxValue != nil {
                lowerLimitValueSlider.maximumValue = Float(maxValue!)
                upperLimitValueSlider.maximumValue = Float(maxValue!)
            }
        }
    }
    var lowerLimitValue: Int! {
        didSet{
            if lowerLimitValue != nil {
                if oldValue == nil || oldValue != lowerLimitValue {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.lowerLimitValueLabel.text = "\(self.lowerLimitValue)"
                        self.lowerLimitValueSlider.value = Float(self.lowerLimitValue)
                    })
                }
            }
        }
    }

    var upperLimitValue: Int! {
        didSet{
            if upperLimitValue != nil {
                if oldValue == nil || oldValue != upperLimitValue {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.upperLimitValueSlider.value = Float(self.upperLimitValue)
                        self.upperLimitValueLabel.text = "\(self.upperLimitValue)"
                    })
                }
            }
        }
    }

    @IBOutlet weak var lowerLimitValueSlider: UISlider!
    @IBOutlet weak var upperLimitValueSlider: UISlider!

    @IBOutlet weak var lowerLimitValueLabel: UILabel!
    @IBOutlet weak var upperLimitValueLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusNameLabel: UILabel!

    @IBAction func changeValue(sender: AnyObject) {
        let changedSlider = sender as! UISlider

        if changedSlider == lowerLimitValueSlider {
            lowerLimitValue = Int(changedSlider.value)
        }else {
            upperLimitValue = Int(changedSlider.value)
        }
        delegate?.setIntervalStatus(self, lowerLimitValue: self.lowerLimitValue!, upperLimitValue: self.upperLimitValue!)
    }

}


