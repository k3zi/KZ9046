//
//  DietaryReferenceIntakeTests.swift
//  KZ9046Tests
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import XCTest
@testable import struct KZ9046.DietaryReferenceIntake

class DietaryReferenceIntakeTests: XCTestCase {

    // Results observed from https://globalrph.com/medcalcs/estimated-energy-requirement-eer-equation/
    func testRandom1() {
        var ref = DietaryReferenceIntake(age: .years(18), height: .init(value: 165.1, unit: .centimeters), weight: .init(value: 190, unit: .pounds), gender: .male, physicalActivity: .active)
        XCTAssertEqual(ref.estimatedEnergyRequirement.value, 3777, accuracy: 1)
    }

}
