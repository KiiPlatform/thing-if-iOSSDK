import UIKit

import ThingIFSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonCreateTrigger() {
        let APP_ID = "a4c6c6a7"
        let APP_KEY = "1154dcfd901bf1fdf5606d3b3d92e095"
        let DEMO_SCHEMA_NAME = "SmartLightDemo"
        let DEMO_SCHEMA_VERSION = 1

        let app = App(appID: APP_ID, appKey: APP_KEY, site: Site.JP)
        let owner = Owner(typedID: TypedID(type: "user", id: "88eb20051321-743a-5e11-a7d9-0ce9503d"),
            accessToken: "0nnEiJMO_sVQLTUZebhczNdmH6YptA7f6ziKv9xZy60")
        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]]]
        let predicate = StatePredicate(condition: Condition(
            clause: EqualsClause(field: "power", boolValue: true)),
            triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

        let api = ThingIFAPIBuilder(app: app, owner: owner).build()
        let api2 = ThingIFAPIBuilder(app: app, owner: owner).build()
        api2.onboard("test2", thingPassword: "1234", thingType: nil, thingProperties: nil) { (commandTarget:Target?, error: ThingIFError?) -> Void in
            if commandTarget != nil {
                api.onboard("test1", thingPassword: "1234", thingType: nil, thingProperties: nil) { (target: Target?, error: ThingIFError?) -> Void in
                    if target != nil {
                        api.postNewTrigger(DEMO_SCHEMA_NAME, schemaVersion: DEMO_SCHEMA_VERSION, actions: actions, predicate: predicate, target: commandTarget) { (trigger: Trigger?, error: ThingIFError?) -> Void in
                            if trigger != nil {
                                print("API target ID     : " + api.target!.typedID.id)
                                print("Command target ID : " + commandTarget!.typedID.id)
                                print("Trigger command ID: " + trigger!.command!.targetID.id)
                            } else {
                                print("postNewTrigger failed. " + error.debugDescription)
                            }
                        }
                    } else {
                        print("test1 onboard failed. " + error.debugDescription)
                    }
                }
            } else {
                print("test2 onboard failed. " + error.debugDescription)
            }
        }
    }
}

