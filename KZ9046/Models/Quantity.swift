//
//  Quantity.swift
//  KZ9046
//
//  Created by kezi on 4/8/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation
import HealthKit

struct Quantity: Codable {

    let unit: HKUnit
    let quantity: HKQuantity

    enum CodingKeys: String, CodingKey {
        case unitString
        case doubleValue
    }

    // MARK: - Initializers

    init(unit: HKUnit, doubleValue value: Double) {
        self.unit = unit
        quantity = HKQuantity(unit: unit, doubleValue: value)
    }

    // MARK: - Codable

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unitString = try container.decode(String.self, forKey: .unitString)
        let doubleValue = try container.decode(Double.self, forKey: .doubleValue)
        unit = HKUnit(from: unitString)
        quantity = HKQuantity(unit: unit, doubleValue: doubleValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(unit.unitString, forKey: .unitString)
        try container.encode(quantity.doubleValue(for: unit), forKey: .doubleValue)
    }

    // MARK: - HKQuantity Methods

    /*!
     @method        isCompatibleWithUnit:
     @abstract      Returns yes if the receiver's value can be converted to a value of the given unit.
     */
    func `is`(compatibleWith unit: HKUnit) -> Bool {
        return quantity.is(compatibleWith: unit)
    }


    /*!
     @method        doubleValueForUnit:
     @abstract      Returns the quantity value converted to the given unit.
     @discussion    Throws an exception if the receiver's value cannot be converted to one of the requested unit.
     */
    func doubleValue(for unit: HKUnit) -> Double {
        return quantity.doubleValue(for: unit)
    }


    /*!
     @method        compare:
     @abstract      Returns an NSComparisonResult value that indicates whether the receiver is greater than, equal to, or
     less than a given quantity.
     @discussion    Throws an exception if the unit of the given quantity is not compatible with the receiver's unit.
     */
    func compare(_ quantity: HKQuantity) -> ComparisonResult {
        return self.quantity.compare(quantity)
    }
}
