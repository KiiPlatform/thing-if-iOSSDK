//
//  TriggerDetailViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/26/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

struct CommandStruct {
    let schemaName: String!
    let schemaVersion: Int!
    let actions: [Dictionary<String, AnyObject>]!
}

class TriggerDetailViewController: KiiBaseTableViewController, TriggerCommandEditViewControllerDelegate, StatesPredicateViewControllerDelegate {

    @IBOutlet weak var commandDetailLabel: UILabel!

    @IBOutlet weak var statePredicateDetailLabel: UILabel!

    var trigger: Trigger?

    private var statePredicateToSave: StatePredicate?
    private var commandStructToSave: CommandStruct?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if trigger != nil {
            self.navigationItem.title = trigger!.triggerID
        }else {
            self.navigationItem.title = "Create New Trigger"
        }

        if commandStructToSave != nil {
            commandDetailLabel.text = "\(commandStructToSave!.schemaName):\(commandStructToSave!.schemaVersion), actions(\(commandStructToSave!.actions.count))"
        }else {
            if let command = trigger?.command {
                commandDetailLabel.text = "\(command.schemaName):\(command.schemaVersion), actions(\(command.actions.count))"
            }else{
                commandDetailLabel.text = " "
            }
        }

        if statePredicateToSave != nil {
            statePredicateDetailLabel.text = statePredicateToSave!.triggersWhen.toString()
        }else {
            if let statePredicate = trigger?.predicate as? StatePredicate {
                statePredicateDetailLabel.text = statePredicate.triggersWhen.toString()
            }else {
                statePredicateDetailLabel.text = " "
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if trigger != nil {
            commandStructToSave = CommandStruct(schemaName: self.trigger!.command.schemaName, schemaVersion: self.trigger!.command.schemaVersion, actions: self.trigger!.command.actions)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTriggerCommand" {
            if let destVC = segue.destinationViewController as? TriggerCommandEditViewController {
                if self.commandStructToSave == nil {
                    if self.trigger != nil {
                    destVC.commandStruct = CommandStruct(schemaName: self.trigger!.command.schemaName, schemaVersion: self.trigger!.command.schemaVersion, actions: self.trigger!.command.actions)
                    }
                }else {
                    destVC.commandStruct = commandStructToSave
                }
                destVC.delegate = self
            }

        }else if segue.identifier == "editTriggerPredicate" {
            if let destVC = segue.destinationViewController as? StatesPredicateViewController {
                if self.statePredicateToSave == nil {
                    destVC.statePredicate = self.trigger?.predicate as? StatePredicate
                }else {
                    destVC.statePredicate = statePredicateToSave
                }
                destVC.delegate = self
            }
        }
    }

    @IBAction func tapSaveTrigger(sender: AnyObject) {
        self.saveTrigger()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func saveTrigger() {
        if iotAPI != nil && target != nil && commandStructToSave != nil {
            if trigger != nil {
                iotAPI!.patchTrigger(trigger!.triggerID, schemaName: commandStructToSave!.schemaName, schemaVersion: commandStructToSave!.schemaVersion, actions: commandStructToSave!.actions, predicate: statePredicateToSave, completionHandler: { (updatedTrigger, error) -> Void in
                    if updatedTrigger != nil {
                        self.trigger = updatedTrigger
                    }else {
                        self.showAlert("Update Trigger Failed", error: error, completion: nil)
                    }
                })
            }else {
                if statePredicateToSave != nil {
                    iotAPI!.postNewTrigger(commandStructToSave!.schemaName, schemaVersion: commandStructToSave!.schemaVersion, actions: commandStructToSave!.actions, predicate: statePredicateToSave!, completionHandler: { (newTrigger, error) -> Void in
                        if newTrigger != nil {
                            self.trigger = newTrigger
                        }else {
                            self.showAlert("Create Trigger Failed", error: error, completion: nil)
                        }
                    })
                }
            }
        }

    }

    //MARK: delegate function of TriggerCommandEditViewControllerDelegate, called when save command
    func saveCommands(schemaName: String, schemaVersion: Int, actions: [Dictionary<String, AnyObject>]) {
        self.commandStructToSave = CommandStruct(schemaName: schemaName, schemaVersion: schemaVersion, actions: actions)
    }

    func saveStatePredicate(newPredicate: StatePredicate) {
        self.statePredicateToSave = newPredicate
    }

}