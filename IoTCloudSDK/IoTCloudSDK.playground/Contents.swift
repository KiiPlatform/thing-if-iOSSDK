//: Playground - noun: a place where people can play
import Foundation

let path = "https://small-tests.internal.kii.com/iot-api/apps/50a62843/targets/thing:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5/commands?bestEffortLimit=2"
let bestEffortLimit = 2
let range = path.rangeOfString("bestEffortLimit=\(bestEffortLimit)")