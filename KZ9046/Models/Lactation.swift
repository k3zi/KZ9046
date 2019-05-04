//
//  Lactation.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

enum Lactation: Codable {

    case nonLactation
    case durationPostpartum(Duration)

    enum CodingKeys: String, CodingKey {
        case nonLactation
        case durationPostpartum
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let nonLactation = try values.decodeIfPresent(Bool.self, forKey: .nonLactation) ?? false
        if nonLactation {
            self = .nonLactation
        } else {
            self = .durationPostpartum(try values.decode(Duration.self, forKey: .durationPostpartum))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .nonLactation:
            try container.encode(true, forKey: .nonLactation)
        case .durationPostpartum(let duration):
            try container.encode(duration, forKey: .durationPostpartum)
        }
    }

    var milkEnergyOutput: Double {
        switch self {
        case .durationPostpartum(Duration.months(0)..<Duration.months(7)):
            return 500
        case .durationPostpartum(Duration.months(7)..<Duration.months(12)):
            return 400
        default:
            return 0
        }
    }

    var weightLoss: Double {
        switch self {
        case .durationPostpartum(Duration.months(0)..<Duration.months(7)):
            return 170
        default:
            return 0
        }
    }

}
