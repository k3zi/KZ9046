//
//  DietaryReferenceIntake.swift
//  KZ9046
//
//  Created by kezi on 4/28/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

enum Attribute: String, Codable {
    case age
    case gender
    case pregnancy
    case lactation
}

enum Relation: String, Codable {
    case equal = "="
    case notEqual = "!="
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
}

struct Filter: Codable {

    let attribute: Attribute
    let relation: Relation

}

struct Bucket: Codable {

    enum Key: String, Codable {
        case ear
        case rda
        case ai
        case ul
    }

    let filters: [Filter]
    let values: [Key: Double]

}

struct DietaryReferenceIntake: Codable {

    let nutrients: [NutrientType]
    let unit: Dimension
    let buckets: [Bucket]

}
