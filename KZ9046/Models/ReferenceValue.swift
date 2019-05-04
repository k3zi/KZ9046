//
//  ReferenceValue.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

struct ReferenceValue {

    let estimatedAverageRequirement: Measurement<NutrientMass>?
    let recommendedDietaryAllowance: Measurement<NutrientMass>?
    let tolerableUpperIntakeLevel: Measurement<NutrientMass>?
    let adequateIntake: Measurement<NutrientMass>?

    init(ear: Measurement<NutrientMass>? = nil, rda: Measurement<NutrientMass>? = nil, ai: Measurement<NutrientMass>? = nil, ul: Measurement<NutrientMass>? = nil) {
        estimatedAverageRequirement = ear
        recommendedDietaryAllowance = rda
        tolerableUpperIntakeLevel = ul
        // Use rda for ai if ai is not provided.
        adequateIntake = ai ?? rda
    }

}
