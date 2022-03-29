//
//  Coordinates.swift
//  Weather App
//
//  Created by Eric Davis on 28/03/2022.
//

import Foundation

struct Coordinate {
    var lon: Float
    var lat: Float
}

extension Coordinate: Codable {  }

extension Coordinate: Hashable {  }
