//
//  PatchTriggerWithTriggeredCommandFormTest.swift
//  ThingIFSDK
//
//  Created on 2016/10/06.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PatchTriggerWithTriggeredCommandFormTest: SmallTestBase {

    private func createSuccessRequestBody(
      _ form: TriggeredCommandForm,
      setting: TestSetting) -> Dictionary<String, Any>
    {
        let targetID = form.targetID ?? setting.api.target!.typedID
        var command: Dictionary<String, Any> = [
          "schema" : form.schemaName,
          "schemaVersion" : form.schemaVersion,
          "actions" : form.actions,
          "issuer" : setting.owner.typedID.toString(),
          "target" : targetID.toString()
        ]
        command["title"] = form.title
        command["description"] = form.commandDescription
        command["metadata"] = form.metadata

        return [ "triggersWhat": TriggersWhat.command.rawValue,
                 "command" : command ]
    }


}
