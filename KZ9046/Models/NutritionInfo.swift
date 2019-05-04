//
//  NutritionInfo.swift
//  KZ9046
//
//  Created by kezi on 5/4/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

struct NutritionInfo: Codable {

    var nutrients: [Nutrient]

    func add(nutrient: Nutrient) {
        if let existingNutrient = nutrients.first(where: { $0.type == nutrient.type }) {

        }
    }

}
