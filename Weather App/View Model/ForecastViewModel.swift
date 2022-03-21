//
//  ForecastViewModel.swift
//  Weather App
//
//  Created by Eric Davis on 18/03/2022.
//

import Foundation
import Combine

class ForecastViewModel {
        
    @Published var fetchedWeather: Weather?
    
    func getWeatherFor(location: String) {
        WeatherRequestLocation(location: location).send { response in
            switch response {
            case .success(let weather):
                self.fetchedWeather = weather
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getWeatherFor(lat: String, lon: String) {
        WeatherRequestLatLon(lat: lat, lon: lon).send { response in
            switch response {
            case .success(let weather):
                self.fetchedWeather = weather
            case .failure(let error):
                print(error)
            }
        }
     }
    
    func weatherImage(for number: Int) -> String {
        switch number {
            //Thunderstorm
        case 200...232: return  "cloud.bolt.rain"
            //Drizzle
        case 300...321: return "cloud.drizzle"
            //Rainy
        case 500...531: return  "cloud.rain"
            //Snowing
        case 600...622: return "cloud.snow"
            //Smoke
        case 711: return "smoke"
            //Hazy
        case 721: return "sun.haze"
            //Fogy
        case 741: return "cloud.fog"
            //Dusty
        case 761: return "dust"
            //Tornado
        case 781: return "tornado"
            //Scattered clouds
        case 801...802: return "cloud.sun"
            //Cloudy
        case 803...804: return "cloud"
            //Clear sky
        default: return "sun.max"
        }
    }
}
