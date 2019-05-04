//
//  NutrientMassTests.swift
//  KZ9046Tests
//
//  Created by kezi on 4/25/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import XCTest
@testable import class KZ9046.NutrientMass

class NutrientMassTests: XCTestCase {

    func testVitaminARetinol() {
        // 1 µg retinol = ~3.33 IU
        let unit = try! NutrientMass.internationalUnits(nutrient: .vitaminARetinol)
        let micrograms = Measurement<UnitMass>(value: 1, unit: UnitMass.micrograms)
        let internationalUnits = micrograms.converted(to: unit)
        XCTAssertEqual(internationalUnits.value, 3.33, accuracy: 0.01)
    }

    func testVitaminABetaCarotene() {
        // 3000 µg beta-carotene = 5000 IU
        let unit = try! NutrientMass.internationalUnits(nutrient: .vitaminABetaCarotene)
        let micrograms = Measurement<UnitMass>(value: 3000, unit: UnitMass.micrograms)
        let internationalUnits = micrograms.converted(to: unit)
        XCTAssertEqual(internationalUnits.value, 5000, accuracy: 0.01)
    }

    func testVitaminAAlphaCarotene() {
        // 24 µg alpha-carotene = 20 IU
        let unit = try! NutrientMass.internationalUnits(nutrient: .vitaminAAlphaCarotene)
        let micrograms = Measurement<UnitMass>(value: 24, unit: UnitMass.micrograms)
        let internationalUnits = micrograms.converted(to: unit)
        XCTAssertEqual(internationalUnits.value, 20, accuracy: 0.01)
    }

    func testVitaminABetaCryptoxanthin() {
        // 24 µg beta-cryptoxanthin = 20 IU
        let unit = try! NutrientMass.internationalUnits(nutrient: .vitaminABetaCryptoxanthi)
        let micrograms = Measurement<UnitMass>(value: 24, unit: UnitMass.micrograms)
        let internationalUnits = micrograms.converted(to: unit)
        XCTAssertEqual(internationalUnits.value, 20, accuracy: 0.01)
    }

}
