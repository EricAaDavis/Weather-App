//
//  DecimalRounding.swift
//  Weather App
//
//  Created by Eric Davis on 24/03/2022.
//

import Foundation

public enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
}

// Round to the specific decimal place
public func preciseRound(
    _ value: Float,
    precision: RoundingPrecision = .ones) -> Float
{
    switch precision {
    case .ones:
        return round(value)
    case .tenths:
        return round(value * 10) / 10.0
    case .hundredths:
        return round(value * 100) / 100.0
    }
}

struct Rounding {
    
//    // Examples
//    preciseRound(1.27) // Result is 1
//    preciseRound(1.27, precision: .tenths) // Result is 1.3
    // Specify the decimal place to round to using an enum
    
}
