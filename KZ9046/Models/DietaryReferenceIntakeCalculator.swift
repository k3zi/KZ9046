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
        case (Duration.months(0)...Duration.months(35), _):
            value = (89 * weightKg - 100) + energyDeposition

        // Children and Adolescents 3-18 years
        case (Duration.years(3)...Duration.years(18), .male):
            let pa = physicalActivity.coefficient(forAge: age, gender: .male)
            value = 88.5 - (61.9 * yearsOld) + pa * ((26.7 * weightKg) + (903 * heightM)) + energyDeposition
        case (Duration.years(3)...Duration.years(18), .female):
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
        switch nutrient {
        case .vitaminARetinol, .vitaminABetaCarotene, .vitaminAAlphaCarotene, .vitaminABetaCryptoxanthi:
            var ear: Double
            var rda: Double
            var ul: Double

            switch (age, gender) {
            // Infants
            case (Duration.months(0)...Duration.months(6), _):
                return ReferenceValue(rda: .init(value: 400, unit: .micrograms), ul: .init(value: 600, unit: .micrograms))
            case (Duration.months(7)...Duration.months(12), _):
                return ReferenceValue(rda: .init(value: 500, unit: .micrograms), ul: .init(value: 600, unit: .micrograms))

            // Children
            case (Duration.years(1)...Duration.years(3), _):
                ear = 210; rda = 300; ul = 600
            case (Duration.years(4)...Duration.years(8), _):
                ear = 275; rda = 400; ul = 900

            // Males
            case (Duration.years(9)...Duration.years(13), .male):
                ear = 445; rda = 600; ul = 1700
            case (Duration.years(14)...Duration.years(18), .male):
                ear = 630; rda = 900; ul = 2800
            case (Duration.years(19)..., .male):
                ear = 625; rda = 900; ul = 3000

            // Females
            case (Duration.years(9)...Duration.years(13), .female):
                ear = 420; rda = 600; ul = 1700
            case (Duration.years(14)...Duration.years(18), .female):
                ear = 485; rda = 700; ul = 2800
            case (Duration.years(19)..., .female):
                ear = 500; rda = 700; ul = 3000
            default: fatalError()
            }

            // Pregnancy
            if pregnancy != .nonPregnant {
                switch age {
                case ...Duration.years(18):
                    ear = 530; rda = 750; ul = 2800
                case Duration.years(19)...:
                    ear = 550; rda = 770; ul = 3000
                default: break
                }
            }

            // Lactation
            if case .nonLactation = lactation {
                switch age {
                case ...Duration.years(18):
                    ear = 885; rda = 1200; ul = 2800
                case Duration.years(19)...:
                    ear = 900; rda = 1300; ul = 3000
                default: break
                }
            }

            return ReferenceValue(ear: .init(value: ear, unit: .micrograms), rda: .init(value: rda, unit: .micrograms), ul: .init(value: ul, unit: .micrograms))
        case .vitaminD:
            let ear: Double = 10
            var rda: Double
            var ul: Double

            switch age {
            // Infants
            case Duration.months(0)...Duration.months(6):
                return ReferenceValue(ai: .init(value: 10, unit: .micrograms), ul: .init(value: 25, unit: .micrograms))
            case Duration.months(7)...Duration.months(12):
                return ReferenceValue(ai: .init(value: 10, unit: .micrograms), ul: .init(value: 38, unit: .micrograms))

            // Children
            case Duration.years(1)...Duration.years(3):
                rda = 15; ul = 63
            case Duration.years(4)...Duration.years(8):
                rda = 15; ul = 75

            // Males / Females
            case Duration.years(9)...Duration.years(70):
                rda = 15; ul = 100
            case Duration.years(70)...:
                rda = 20; ul = 100

            default: fatalError()
            }

            return ReferenceValue(ear: .init(value: ear, unit: .micrograms), rda: .init(value: rda, unit: .micrograms), ul: .init(value: ul, unit: .micrograms))
        case .vitaminE:
            var ear: Double
            var rda: Double
            var ul: Double

            switch age {
            // Infants
            case Duration.months(0)...Duration.months(6):
                return ReferenceValue(ai: .init(value: 4, unit: .milligrams))
            case Duration.months(7)...Duration.months(12):
                return ReferenceValue(ai: .init(value: 5, unit: .milligrams))

            // Children
            case Duration.years(1)...Duration.years(3):
                ear = 5; rda = 6; ul = 200
            case Duration.years(4)...Duration.years(8):
                ear = 6; rda = 7; ul = 300

            // Males / Females
            case Duration.years(9)..<Duration.years(14):
                ear = 9; rda = 11; ul = 600
            case Duration.years(14)..<Duration.years(19):
                ear = 12; rda = 15; ul = 800
            case Duration.years(19)...:
                ear = 12; rda = 15; ul = 1000

            default: fatalError()
            }

            // Lactation
            if case .nonLactation = lactation {
                ear = 16; rda = 19
            }

            return ReferenceValue(ear: .init(value: ear, unit: .milligrams), rda: .init(value: rda, unit: .milligrams), ul: .init(value: ul, unit: .milligrams))
        case .vitaminK:
            var ai: Double

            switch (age, gender) {
            // Infants
            case (Duration.months(0)...Duration.months(6), _):
                ai = 2.0
            case (Duration.months(7)...Duration.months(12), _):
                ai = 2.5

            // Children
            case (Duration.years(1)...Duration.years(3), _):
                ai = 30
            case (Duration.years(4)...Duration.years(8), _):
                ai = 55

            // Youth
            case (Duration.years(9)...Duration.years(13), _):
                ai = 60
            case (Duration.years(14)...Duration.years(18), _):
                ai = 75

            // Adults
            case (Duration.years(19)..., .male):
                ai = 120
            case (Duration.years(19)..., .female):
                ai = 90

            default: fatalError()
            }

            return ReferenceValue(ai: .init(value: ai, unit: .micrograms))
        default: fatalError()
        }
    }
}
