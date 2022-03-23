//
//  Locations.swift
//  Weather App
//
//  Created by Eric Davis on 21/03/2022.
//

import Foundation

struct Locations: Codable {
    var cityData: [CityData]
    
    enum CodingKeys: String, CodingKey {
        case cityData = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.cityData = try container.decode(Array<CityData>.self, forKey: .cityData)
    }
}
