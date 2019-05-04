//
//  DietaryReferenceIntakeCalculator.swift
//  KZ9046
//
//  Created by kezi on 4/27/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

public struct DietaryReferenceIntakeCalculator {

    typealias Height = Measurement<UnitLength>
    typealias Weight = Measurement<UnitMass>

    let age: Duration
    let height: Height
    let weight: Weight
    let gender: Gender
    let physicalActivity: PhysicalActivity

    let pregnancy: Pregnancy
    let lactation: Lactation

    init(age: Duration, height: Height, weight: Weight, gender: Gender, physicalActivity: PhysicalActivity, pregnancy: Pregnancy = .nonPregnant, lactation: Lactation = .nonLactation) {
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
        self.physicalActivity = physicalActivity
        self.pregnancy = pregnancy
        self.lactation = lactation
    }

    private(set) lazy var energyDeposition: Double = {
        switch age {
        case Duration.months(0)...Duration.months(3):
            return 175
        case Duration.months(4)...Duration.months(6):
            return 56
        case Duration.months(7)...Duration.months(12):
            return 22
        case Duration.months(13)...Duration.years(8):
            return 20
        case Duration.years(9)...Duration.years(18):
            return 25
        case Duration.years(19)...:
            return 0
        default:
            fatalError("Invalid age for calculating energy deposition.")
        }
    }()

    /// Estimated Energy Requirement (kcal / day)
    private(set) lazy var estimatedEnergyRequirement: Measurement<UnitEnergy> = {
        let weightKg = weight.converted(to: .kilograms).value
        let heightM = height.converted(to: .meters).value
        let yearsOld = Double(age.years)

        var value: Double
        switch (age, gender) {
        // Infants and Young Children
        case (Duration.months(0)..<Duration.years(3), _):
            value = (89 * weightKg - 100) + energyDeposition

        // Children and Adolescents 3-18 years
        case (Duration.years(3)..<Duration.years(19), .male):
            let pa = physicalActivity.coefficient(forAge: age, gender: .male)
            value = 88.5 - (61.9 * yearsOld) + pa * ((26.7 * weightKg) + (903 * heightM)) + energyDeposition
        case (Duration.years(3)..<Duration.years(19), .female):
            let pa = physicalActivity.coefficient(forAge: age, gender: .female)
            value = 135.3 - (30.8 * yearsOld) + pa * ((10.0 * weightKg) + (934 * heightM)) + energyDeposition

        // Adults 19 Years and Older
        case (Duration.years(19)..., .male):
            let pa = physicalActivity.coefficient(forAge: age, gender: .male)
            value = 662 - (9.53 * yearsOld) + pa * ((15.91 * weightKg) + (539.6 * heightM))
        case (Duration.years(19)..., .female):
            let pa = physicalActivity.coefficient(forAge: age, gender: .female)
            value = 354 - (6.91 * yearsOld) + pa * ((9.36 * weightKg) + (726 * heightM))

        default:
            fatalError("EER not implemented for input age / gender.")
        }

        value += pregnancy.energyDeposition
        value += lactation.milkEnergyOutput - lactation.weightLoss

        return Measurement<UnitEnergy>(value: value, unit: .kilocalories)
    }()

    func referenceValue(for nutrient: NutrientType) -> ReferenceValue {
        // TODO: Read from JSON file.
        fatalError()
    }
}
