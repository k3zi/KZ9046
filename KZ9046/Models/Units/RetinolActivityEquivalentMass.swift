//
//  RetinolActivityEquivalentMass.swift
//  KZ9046
//
//  Created by kezi on 5/4/31 H.
//  Copyright © 31 Heisei kezi. All rights reserved.
//

import Foundation

final class RetinolActivityEquivalentMass: Dimension, Codable {

    enum Symbol: String, Codable {

        case internationalUnits = "IU RAE"
        case micrograms = "μg RAE"
        case milligrams = "mg RAE"

        var converter: UnitConverter {
            switch self {
            case .internationalUnits:
                return UnitConverterLinear(coefficient: 0.3, constant: 0)
            case .micrograms:
                return UnitConverterLinear(coefficient: 1, constant: 0)
            case .milligrams:
                return UnitConverterLinear(coefficient: 1000, constant: 0)
            }
        }

        var unit: RetinolActivityEquivalentMass {
            return .init(symbol: rawValue, converter: converter)
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
        return RetinolActivityEquivalentMass(symbol: Symbol.internationalUnits.rawValue, converter: Symbol.internationalUnits.converter)
    }

    class var micrograms: RetinolActivityEquivalentMass {
        return RetinolActivityEquivalentMass(symbol: Symbol.micrograms.rawValue, converter: Symbol.micrograms.converter)
    }

    class var milligrams: RetinolActivityEquivalentMass {
        return RetinolActivityEquivalentMass(symbol: Symbol.milligrams.rawValue, converter: Symbol.milligrams.converter)
    }

    override class func baseUnit() -> RetinolActivityEquivalentMass {
        return micrograms
    }

}
