//
//  PhysicalActivity.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

enum PhysicalActivity {

    case sedentary
    case lowActive
    case active
    case veryActive

    func coefficient(forAge age: Duration, gender: Gender) -> Double {
        switch (activity: self, age: age, gender: gender) {
        case (.sedentary, _, _):
            return 1

        case (.lowActive, Duration.years(3)...Duration.years(18), .male):
            return 1.13
        case (.lowActive, Duration.years(3)...Duration.years(18), .female):
            return 1.16
        case (.lowActive, Duration.years(19)..., .male):
            return 1.11
        case (.lowActive, Duration.years(19)..., .female):
            return 1.12

        case (.active, Duration.years(3)...Duration.years(18), .male):
            return 1.26
        case (.active, Duration.years(3)...Duration.years(18), .female):
            return 1.31
        case (.active, Duration.years(19)..., .male):
            return 1.25
        case (.active, Duration.years(19)..., .female):
            return 1.27

        case (.veryActive, Duration.years(3)...Duration.years(18), .male):
            return 1.42
        case (.veryActive, Duration.years(3)...Duration.years(18), .female):
            return 1.56
        case (.veryActive, Duration.years(19)..., .male):
            return 1.48
        case (.veryActive, Duration.years(19)..., .female):
            return 1.45

        default:
            fatalError("Invalid age provided for physical activity coefficient.")
        }
    }

}
