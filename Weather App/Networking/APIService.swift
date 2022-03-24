//
//  APIService.swift
//  Weather App
//
//  Created by Eric Davis on 16/03/2022.
//

import Foundation

struct WeatherRequestLocation: APIRequest {
    typealias Response = Weather
    
    var location: String
    
    var queryItems: [URLQueryItem]? {
        let queryItems = [
            URLQueryItem(name: "q", value: location),
            URLQueryItem(name: "appid", value: "e3054674cca873c300c8558256792c23"),
            URLQueryItem(name: "units", value: "metric")
        ]
       return queryItems
    }
}

struct WeatherRequestLatLon: APIRequest {
    
    typealias Response = Weather
    
    var lat: String
    var lon: String
    
    var queryItems: [URLQueryItem]? {
        let queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "appid", value: "e3054674cca873c300c8558256792c23"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return queryItems
    }
}

struct CityAutocompleteRequest: APIRequest {
    typealias Response = Locations
    
    var scheme = "http"
    var host = "geodb-free-service.wirefreethought.com"
    var path = "/v1/geo/cities"
    
    var locationPrefix: String
    
    var queryItems: [URLQueryItem]? {
        let queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "namePrefix", value: locationPrefix)
        ]
        return queryItems
    }
}

