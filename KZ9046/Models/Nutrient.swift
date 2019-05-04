//
//  Nutrient.swift
//  KZ9046
//
//  Created by kezi on 5/4/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

struct Nutrient: Codable {

    let type: NutrientType
    let amount: Measurement<NutrientMass>

}
