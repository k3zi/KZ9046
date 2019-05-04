//
//  DurationTests.swift
//  KZ9046Tests
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import XCTest
@testable import struct KZ9046.Duration

class DurationTests: XCTestCase {

    func testRandom1() {
        let duration = Duration.months(0)
        XCTAssertEqual(duration.days, 0)
        XCTAssertEqual(duration.months, 0)
        XCTAssertEqual(duration.years, 0)
    }

    func testRandom2() {
        let duration = Duration.months(5)
        XCTAssertEqual(duration.days, 0)
        XCTAssertEqual(duration.months, 5)
        XCTAssertEqual(duration.years, 0)
    }

    func testRandom3() {
        let duration = Duration.months(15)
        XCTAssertEqual(duration.days, 0)
        XCTAssertEqual(duration.months, 3)
        XCTAssertEqual(duration.years, 1)
    }

    func testEqauality() {
        let x = Duration.years(10)
        let y = Duration.years(10)

        XCTAssertEqual(x, y)
    }

    func testComparison1() {
        let x = Duration.years(10)
        let y = Duration.years(15)

        XCTAssertLessThan(x, y)
    }

    func testComparison2() {
        let x = Duration.months(10)
        let y = Duration.months(15)

        XCTAssertLessThan(x, y)
    }

    func testComparison3() {
        let x = Duration.months(20)
        let y = Duration.months(10)

        XCTAssertGreaterThan(x, y)
    }

}
