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

        /// Estimated Average Requirement
        case ear

        /// Recommended Dietary Allowance
        case rda

        /// Adequate Intake
        case ai

        /// Tolerable Upper Intake Level
        case ul

    }

    let filters: [Filter]
    let values: [Key: Double]

}

struct DietaryReferenceIntake: Codable {

    let nutrients: [NutrientType]
    let unit: Dimension
    let buckets: [Bucket]

    enum CodingKeys: String, CodingKey {

        case nutrients
        case unit
        case buckets

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nutrients = try container.decode([NutrientType].self, forKey: .nutrients)
        buckets = try container.decode([Bucket].self, forKey: .buckets)

        let unitString = try container.decode(String.self, forKey: .unit)
        if let symbol = RetinolActivityEquivalentMass.Symbol(rawValue: unitString) {
            unit = symbol.unit
        } else {
            unit = UnitMass(symbol: unitString)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nutrients, forKey: .nutrients)
        try container.encode(buckets, forKey: .buckets)
        try container.encode(unit.symbol, forKey: .unit)
    }

}
