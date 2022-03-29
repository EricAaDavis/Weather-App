//
//  CityWeather.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import Foundation

struct Weather: Codable {
    
    var coordinate: Coordinate
    var weatherDescription: [WeatherDescription]
    var condition: Condition
    var wind: Wind
    var clouds: Clouds
    var sys: Sys
    var cityName: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weatherDescription = "weather"
        case condition = "main"
        case wind
        case clouds
        case sys
        case cityName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        self.weatherDescription = try container.decode(Array<WeatherDescription>.self, forKey: .weatherDescription)
        self.condition = try container.decode(Condition.self, forKey: .condition)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.cityName = try container.decode(String.self, forKey: .cityName)
    }
}

extension Weather: Hashable { }
