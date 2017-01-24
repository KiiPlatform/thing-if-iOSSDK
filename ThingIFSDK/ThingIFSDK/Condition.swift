//
//  Condition.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
/** Class represents Condition */
open class Condition : NSObject, NSCoding {
    open let clause: TriggerClause

    /** Init Condition with Clause

     - Parameter clause: Clause instance
     */
    public init(_ clause: TriggerClause) {
        self.clause = clause
    }

    public required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! TriggerClause);
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clause)
    }

    /** Get Condition as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    open func makeDictionary() -> [ String : Any ] {
        return self.clause.makeDictionary()
    }

    /*
     TODO: We should change 2 methods below to initializer. We will do
     that in another PR.

    class func conditionWithNSDict(_ conditionDict: NSDictionary) -> Condition?{
        if let clause = Condition.clauseWithNSDict(conditionDict) {
            return Condition(clause: clause)
        }else {
            return nil
        }
    }

    class func clauseWithNSDict(_ clauseDict: NSDictionary) -> Clause?{
        var clause: Clause?
        if let type = clauseDict["type"] as? String {
            switch type {
            case "range":
                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber, let lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber, let field = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool, let lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: field, lowerLimitInt: lowerLimitNumber.intValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.intValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: field, lowerLimitDouble: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber,
                    let filed = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: filed, upperLimitInt: upperLimitNumber.intValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, upperLimitDouble: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber,
                    let filed = clauseDict["field"] as? String {
                    if let lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if lowerLimitNumber.isInt() {
                            clause = RangeClause(field: filed, lowerLimitInt: lowerLimitNumber.intValue, lowerIncluded: lowerIncluded)
                        }else if lowerLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, lowerLimitDouble: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded)
                        }
                    }
                    break
                }
                break

            case "eq":
                if let field = clauseDict["field"] as? String, let value = clauseDict["value"] {
                    if value is String {
                        clause = EqualsClause(field: field, stringValue: value as! String)
                    }else if value is NSNumber {
                        let numberValue = value as! NSNumber
                        if numberValue.isBool() {
                            clause = EqualsClause(field: field, boolValue: numberValue.boolValue)
                        }else {
                            clause = EqualsClause(field: field, intValue: numberValue.intValue)
                        }
                    }
                }

            case "not":
                if let clauseDict = clauseDict["clause"] as? NSDictionary {
                    if let equalClause = Condition.clauseWithNSDict(clauseDict) as? EqualsClause{
                        clause = NotEqualsClause(equalStmt: equalClause)
                    }
                }

            case "and":
                let andClause = AndClause()
                if let clauseDicts = clauseDict["clauses"] as? NSArray {
                    for clauseDict in clauseDicts {
                        if let subClause = Condition.clauseWithNSDict(clauseDict as! NSDictionary) {
                            andClause.add(subClause)
                        }
                    }
                }
                clause = andClause

            case "or":
                let orClause = OrClause()
                if let clauseDicts = clauseDict["clauses"] as? NSArray {
                    for clauseDict in clauseDicts {
                        if let subClause = Condition.clauseWithNSDict(clauseDict as! NSDictionary) {
                            orClause.add(subClause)
                        }
                    }
                }
                clause = orClause
                
            default:
                break
            }
        }
        return clause
    }
    */
}
