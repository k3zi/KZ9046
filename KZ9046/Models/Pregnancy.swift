//
//  Pregnancy.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

enum Pregnancy: String, Codable {

    case nonPregnant
    case firstTrimester
    case secondTrimester
    case thirdTrimester

    var energyDeposition: Double {
        switch self {
        case .nonPregnant, .firstTrimester:
            return 0
        case .secondTrimester:
            return 340
        case .thirdTrimester:
            return 452
        }
    }

}
