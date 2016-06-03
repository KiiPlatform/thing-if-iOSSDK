//
//  Condition.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
/** Class represents Condition */
public class Condition : NSObject, NSCoding {
    public let clause: Clause!

    /** Init Condition with Clause

     - Parameter clause: Clause instance
     */
    public init(clause:Clause) {
        self.clause = clause
    }

    public required init(coder aDecoder: NSCoder) {
        self.clause = aDecoder.decodeObjectForKey("clause") as! Clause
        super.init();
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.clause, forKey: "clause")
    }

    /** Get Condition as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    public func toNSDictionary() -> NSDictionary {
        return self.clause.toNSDictionary()
    }

    class func conditionWithNSDict(conditionDict: NSDictionary) -> Condition?{
        if let clause = Condition.clauseWithNSDict(conditionDict) {
            return Condition(clause: clause)
        }else {
            return nil
        }
    }

    class func clauseWithNSDict(clauseDict: NSDictionary) -> Clause?{
        var clause: Clause?
        if let type = clauseDict["type"] as? String {
            switch type {
            case "range":
                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber, lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber, field = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool, lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: field, lowerLimitInt: lowerLimitNumber.integerValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.integerValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: field, lowerLimitDouble: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded, upperLimit: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let upperLimitNumber = clauseDict["upperLimit"] as? NSNumber,
                    filed = clauseDict["field"] as? String {
                    if let upperIncluded = clauseDict["upperIncluded"] as? Bool {
                        if upperLimitNumber.isInt(){
                            clause = RangeClause(field: filed, upperLimitInt: upperLimitNumber.integerValue, upperIncluded: upperIncluded)
                        }else if upperLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, upperLimitDouble: upperLimitNumber.doubleValue, upperIncluded: upperIncluded)
                        }
                    }
                    break
                }

                if let lowerLimitNumber = clauseDict["lowerLimit"] as? NSNumber,
                    filed = clauseDict["field"] as? String {
                    if let lowerIncluded = clauseDict["lowerIncluded"] as? Bool {
                        if lowerLimitNumber.isInt() {
                            clause = RangeClause(field: filed, lowerLimitInt: lowerLimitNumber.integerValue, lowerIncluded: lowerIncluded)
                        }else if lowerLimitNumber.isDouble() {
                            clause = RangeClause(field: filed, lowerLimitDouble: lowerLimitNumber.doubleValue, lowerIncluded: lowerIncluded)
                        }
                    }
                    break
                }
                break

            case "eq":
                if let field = clauseDict["field"] as? String, value = clauseDict["value"] {
                    if value is String {
                        clause = EqualsClause(field: field, stringValue: value as! String)
                    }else if value is NSNumber {
                        let numberValue = value as! NSNumber
                        if numberValue.isBool() {
                            clause = EqualsClause(field: field, boolValue: numberValue.boolValue)
                        }else {
                            clause = EqualsClause(field: field, intValue: numberValue.integerValue)
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
}
