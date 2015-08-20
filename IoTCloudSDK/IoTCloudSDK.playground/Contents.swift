//: Playground - noun: a place where people can play
import Foundation

let nsdict = ["key1":true, "key2": 3, "key3": "string", "key4":["key5", true]] as NSDictionary

let dict = nsdict as! Dictionary<String, AnyObject>

for (key, value) in dict {
    print(value.dynamicType)
}

