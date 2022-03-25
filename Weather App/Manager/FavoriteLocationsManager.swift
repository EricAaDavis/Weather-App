//
//  FavoriteLocationsManager.swift
//  Weather App
//
//  Created by Eric Davis on 25/03/2022.
//

import Foundation

final class FavoriteLocationsManager {
    
    private let store: WeatherStore = WeatherStore.shared
    
    var favoriteLocations: [String] {
        store.storedWeatherLocations
    }
    
    func saveFavoriteLocation(location: String) {
        var storedLocations = favoriteLocations
        
        if storedLocations.contains(location) {
            print("Already saved")
            return
        }
        
        storedLocations.append(location)
        store.storedWeatherLocations = storedLocations
    }
    
    func removeFavoriteLocation(location: String) {
        var storedLocations = favoriteLocations
        
        storedLocations.removeAll { $0 == location }
        store.storedWeatherLocations = storedLocations
    }
}
