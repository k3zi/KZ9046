//
//  Minerals.swift
//  KZ9046
//
//  Created by kezi on 4/14/31 H.
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

struct Nutrient: Codable {

    let type: NutrientType
    let amount: Measurement<NutrientMass>

}

enum NutrientType: String, Codable {

    enum Kind {

        case mineral
        case vitamin
        case macronutrient

    }

    // Minerals
    case calcium
    case chromium
    case copper
    case fluoride
    case iodine
    case iron
    case magnesium
    case molybdenum
    case nickel
    case phosphorus
    case selenium
    case zinc
    case potassium
    case sodium
    case chloride

    // Macronutrients
    case digestibleCarbohydrate
    case totalProtein
    case totalFat
    case linoleicAcid
    case alphaLinolenicAcid
    case totalFiber
    case totalWater

    // Vitamins
    case biotin
    case choline
    case folate
    case pantothenicAcid
    case riboflavin
    case thiamin
    case vitaminARetinol
    case vitaminABetaCarotene
    case vitaminAAlphaCarotene
    case vitaminABetaCryptoxanthi
    case vitaminB6
    case vitaminB12
    case vitaminC
    case vitaminD
    case vitaminE
    case vitaminK

    var kind: Kind {
        switch self {
        case .calcium, .chromium, .copper, .fluoride, .iodine, .iron, .magnesium, .molybdenum, .nickel, .phosphorus, .selenium, .zinc, .potassium, .sodium, .chloride:
            return .mineral
        case .digestibleCarbohydrate, .totalProtein, .totalFat, .linoleicAcid, .alphaLinolenicAcid, .totalFiber, .totalWater:
            return .macronutrient
        case .biotin, .choline, .folate, .pantothenicAcid, .riboflavin, .thiamin, .vitaminARetinol, .vitaminABetaCarotene, .vitaminAAlphaCarotene, .vitaminABetaCryptoxanthi, .vitaminB6, .vitaminB12, .vitaminC, .vitaminD, .vitaminE, .vitaminK:
            return .vitamin
        }
    }

}

enum IUConverterError: Error {
    case noCalculationAvailable
}

class IUConverter: UnitConverterLinear {

    init(nutrient: NutrientType) throws {
        switch nutrient.kind {
        case .mineral, .macronutrient:
            super.init(coefficient: 1, constant: 0)
        case .vitamin:
            // The base unit for UnitMass is kilograms.
            let coefficientInMicrograms: Double
            let mcgRetinolPerIU = 0.3

            switch nutrient {
            // Vitamin A:
            // 1 IU = 0.3 mcg retinol
            // 1 IU = 0.6 mcg beta-carotene
            // 1 mcg RAE = 1 mcg retinol
            // 1 mcg RAE = 2 mcg supplemental beta-carotene
            // 1 mcg RAE = 12 mcg beta-carotene
            // 1 mcg RAE = 24 mcg alpha-carotene
            // 1 mcg RAE = 24 mcg beta-cryptoxanthi
            case .vitaminARetinol:
                coefficientInMicrograms = mcgRetinolPerIU
            case .vitaminABetaCarotene:
                coefficientInMicrograms = mcgRetinolPerIU * 2
            case .vitaminAAlphaCarotene, .vitaminABetaCryptoxanthi:
                coefficientInMicrograms = mcgRetinolPerIU * 4
            default:
                throw IUConverterError.noCalculationAvailable
            }

            super.init(coefficient: Measurement<UnitMass>(value: coefficientInMicrograms, unit: .micrograms).converted(to: .kilograms).value, constant: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

open class NutrientMass: UnitMass {

    class func internationalUnits(nutrient: NutrientType) throws -> NutrientMass {
        return NutrientMass(symbol: "IU", converter: try IUConverter(nutrient: nutrient))
    }

    open class override var micrograms: NutrientMass {
        return NutrientMass(symbol: "μg")
    }

    open class override var milligrams: NutrientMass {
        return NutrientMass(symbol: "mg")
    }

}

final class RetinolActivityEquivalentMass: Dimension, Codable {

    enum Symbol: String, Codable {
        case internationalUnit = "IU"

        var converter: UnitConverter {
            switch self {
            case .internationalUnit:
                return UnitConverterLinear(coefficient: 0.3, constant: 0)
            }
        }
    }

    let raeSymbol: String
    let raeConverter: UnitConverter

    override init(symbol: String, converter: UnitConverter) {
        raeSymbol = symbol
        raeConverter = converter
        super.init(symbol: raeSymbol, converter: raeConverter)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        let symbol = try values.decode(Symbol.self)
        raeSymbol = symbol.rawValue
        raeConverter = symbol.converter
        super.init(symbol: raeSymbol, converter: raeConverter)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raeSymbol)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class var internationalUnits: RetinolActivityEquivalentMass {
        return RetinolActivityEquivalentMass(symbol: "IU", converter: UnitConverterLinear(coefficient: 0.3, constant: 0))
    }

    class var micrograms: RetinolActivityEquivalentMass {
        return RetinolActivityEquivalentMass(symbol: "μg", converter: UnitConverterLinear(coefficient: 1, constant: 0))
    }

    class var milligrams: RetinolActivityEquivalentMass {
        return RetinolActivityEquivalentMass(symbol: "mg", converter: UnitConverterLinear(coefficient: 1000, constant: 0))
    }

    override class func baseUnit() -> RetinolActivityEquivalentMass {
        return micrograms
    }

}
