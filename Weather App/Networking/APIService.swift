//
//  APIService.swift
//  Weather App
//
//  Created by Eric Davis on 16/03/2022.
//

import Foundation

//https://api.openweathermap.org/data/2.5/weather?q=oslo&appid=e3054674cca873c300c8558256792c23

struct WeatherRequest: APIRequest {
    typealias Response = CityWeather
    
    var path: String = "/data/2.5/weather"
    
    var queryItems: [URLQueryItem]? = [
        URLQueryItem(name: "q", value: "oslo"),
        URLQueryItem(name: "appid", value: "e3054674cca873c300c8558256792c23")
    ]
    

    
}















