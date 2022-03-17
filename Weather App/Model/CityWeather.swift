//
//  CityWeather.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import Foundation

struct CityWeather: Codable {
    var weather: [weather]
    var main: Main
    var wind: Wind
    var clouds: Clouds
    var name: String
}

