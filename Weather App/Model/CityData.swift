//
//  CityData.swift
//  Weather App
//
//  Created by Eric Davis on 21/03/2022.
//

import Foundation

struct CityData: Codable {
    var city: String
    var name: String
    var country: String
    var countryCode: String
    var latitude: Double
    var longitude: Double
}
