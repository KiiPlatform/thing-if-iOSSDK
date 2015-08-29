//
//  ClauseHelper.swift
//  SampleProject
//
//  Created by Yongping on 8/29/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import Foundation
import IoTCloudSDK

enum ClauseType: String {
    case And = "And"
    case Or = "Or"
    case Equals = "="
    case NotEquals = "!="
    case LessThan = "<"
    case GreaterThan = ">"
    case LessThanOrEquals = "<="
    case GreaterThanOrEquals = ">="
    case LeftOpen = "( ]"
    case RightOpen = "[ )"
    case BothOpen = "( )"
    case BothClose = "[ ]"

    static func getTypesArray() -> [ClauseType] {
        return [ClauseType.And,
            ClauseType.Or,
            ClauseType.Equals,
            ClauseType.NotEquals,
            ClauseType.LessThan,
            ClauseType.LessThanOrEquals,
            ClauseType.GreaterThan,
            ClauseType.GreaterThanOrEquals,
            ClauseType.BothOpen,
            ClauseType.BothClose,
            ClauseType.LeftOpen,
            ClauseType.RightOpen
        ]
    }

    static func getClauseType(clause: Clause) -> ClauseType? {
        if clause is AndClause {
            return ClauseType.And
        }else if clause is OrClause {
            return ClauseType.Or
        }else if clause is EqualsClause {
            return ClauseType.Equals
        }else if clause is NotEqualsClause {
            return ClauseType.NotEquals
        } else if clause is RangeClause {
            let nsdict = clause.toNSDictionary()
            if let _ = nsdict["lowerLimit"], _ = nsdict["upperLimit"], lowerIncluded = nsdict["lowerIncluded"] as? Bool, upperIncluded = nsdict["upperIncluded"] as? Bool{
                if lowerIncluded && upperIncluded {
                    return ClauseType.BothClose
                }else if !lowerIncluded && upperIncluded {
                    return ClauseType.LeftOpen
                }else if lowerIncluded && !upperIncluded {
                    return ClauseType.RightOpen
                }else {
                    return ClauseType.BothOpen
                }
            }

            if let _ = nsdict["lowerLimit"], lowerIncluded = nsdict["lowerIncluded"] as? Bool {
                if lowerIncluded {
                    return ClauseType.GreaterThanOrEquals
                }else {
                    return ClauseType.GreaterThan
                }
            }

            if let _ = nsdict["upperLimit"], upperIncluded = nsdict["upperIncluded"] as? Bool{
                if upperIncluded {
                    return ClauseType.LessThanOrEquals
                }else {
                    return ClauseType.LessThan
                }
            }
            return nil
        }else{
            return nil
        }
    }

    static func getInitializedClause(clauseType: ClauseType, statusSchema: StatusSchema?) -> Clause? {
        var initializedClause: Clause?

        if clauseType == ClauseType.And {
            initializedClause = AndClause()
        }else if clauseType == ClauseType.Or {
            initializedClause = OrClause()
        }

        if statusSchema != nil {
            let statusType = statusSchema!.type
            let statusName = statusSchema!.name
            switch clauseType {
            case .Equals:
                switch statusType! {
                case StatusType.BoolType:
                    initializedClause = EqualsClause(field: statusName, value: false)
                case StatusType.IntType:
                    initializedClause = EqualsClause(field: statusName, value: 0)
                case StatusType.StringType:
                    initializedClause = EqualsClause(field: statusName, value: "")
                default:
                    break
                }

            case .NotEquals:
                switch statusType! {
                case StatusType.BoolType:
                    initializedClause = NotEqualsClause(field: statusName, value: false)
                case StatusType.IntType:
                    initializedClause = NotEqualsClause(field: statusName, value: 0)
                case StatusType.StringType:
                    initializedClause = NotEqualsClause(field: statusName, value: "")
                default:
                    break
                }

            case .LessThan, .LessThanOrEquals:

                let upperIncluded: Bool!
                if clauseType == ClauseType.LessThanOrEquals {
                    upperIncluded = true
                }else {
                    upperIncluded = false
                }

                switch statusType! {
                case StatusType.IntType:
                    initializedClause = RangeClause(field: statusName, upperLimit: 0, upperIncluded: upperIncluded)
                case StatusType.DoubleType:
                    initializedClause = RangeClause(field: statusName, upperLimit: 0.0, upperIncluded: upperIncluded)
                default:
                    break
                }

            case .GreaterThan, .GreaterThanOrEquals:
                let lowerIncluded: Bool!
                if clauseType == ClauseType.GreaterThanOrEquals {
                    lowerIncluded = true
                }else {
                    lowerIncluded = false
                }
                switch statusType! {
                case StatusType.IntType:
                    initializedClause = RangeClause(field: statusName, lowerLimit: 0, lowerIncluded: lowerIncluded)
                case StatusType.DoubleType:
                    initializedClause = RangeClause(field: statusName, lowerLimit: 0.0, lowerIncluded: lowerIncluded)
                default:
                    break
                }

            case .LeftOpen, .RightOpen, .BothClose, .BothOpen:
                let upperIncluded: Bool!
                if clauseType == ClauseType.LeftOpen || clauseType == ClauseType.BothClose {
                    upperIncluded = true
                }else {
                    upperIncluded = false
                }

                let lowerIncluded: Bool!
                if clauseType == ClauseType.RightOpen || clauseType == ClauseType.BothClose {
                    lowerIncluded = true
                }else {
                    lowerIncluded = false
                }

                switch statusType! {
                case StatusType.IntType:
                    initializedClause = RangeClause(field: statusName, lowerLimit: 0, lowerIncluded: lowerIncluded, upperLimit: 0, upperIncluded: upperIncluded)
                case StatusType.DoubleType:
                    initializedClause = RangeClause(field: statusName, lowerLimit: 0.0, lowerIncluded: lowerIncluded, upperLimit: 0.0, upperIncluded: upperIncluded)
                default:
                    break
                }

            default:
                break
            }

        }
        return initializedClause

    }
}
