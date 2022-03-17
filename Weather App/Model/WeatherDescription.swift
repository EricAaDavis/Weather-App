//
//  weather.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import Foundation

struct WeatherDescription: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
    
