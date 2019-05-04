//
//  Age.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

public struct Duration: Codable {

    let startDate: Date

    private var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year], from: startDate, to: .init())
    }

    init(days: Int = 0, months: Int = 0, years: Int = 0) {
        let components = DateComponents(calendar: .current, timeZone: .current, era: nil, year: -years, month: -months, day: -days)
        startDate = Calendar.current.date(byAdding: components, to: .init())!
    }

    static func days(_ value: Int) -> Duration {
        return .init(days: value)
    }

    static func months(_ value: Int) -> Duration {
        return .init(months: value)
    }

    static func years(_ value: Int) -> Duration {
        return .init(years: value)
    }

    var days: Int {
        return dateComponents.day ?? 0
    }

    var months: Int {
        return dateComponents.month ?? 0
    }

    var years: Int {
        return dateComponents.year ?? 0
    }

}

extension Duration: Comparable {

    public static func < (lhs: Duration, rhs: Duration) -> Bool {
        if lhs.years < rhs.years {
            return true
        }

        if lhs.years == rhs.years {
            if lhs.months < rhs.months {
                return true
            }

            if lhs.months == rhs.months {
                return lhs.days < rhs.days
            }
        }

        return false
    }

}

extension Duration: Equatable {

    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.years == rhs.years && lhs.months == rhs.months && lhs.days == rhs.days
    }

}
