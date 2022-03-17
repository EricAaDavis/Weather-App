//
//  CityWeather.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import Foundation

struct CityWeather: Codable {
    var weather: [weather]
    var condition: Condition
    var wind: Wind
    var clouds: Clouds
    var name: String
    
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case condition = "main"
        case wind
        case clouds
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.weather = try container.decode(Array<weather>.self, forKey: .weather)
        self.condition = try container.decode(Condition.self, forKey: .condition)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
