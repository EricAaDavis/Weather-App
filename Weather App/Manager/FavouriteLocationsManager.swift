//
//  FavoriteLocationsManager.swift
//  Weather App
//
//  Created by Eric Davis on 25/03/2022.
//

import Foundation

final class FavouriteLocationsManager {
    
//    static let shared = FavouriteLocationsManager()
    
    private let store: WeatherStore = WeatherStore.shared
    
    var favoriteLocations: [String] {
        store.storedWeatherLocations
    }
    
    //Checks whether the passed in location is stored in the store
    func containsFavoriteLocation(location: String) -> Bool {
        let locationLowerCased = location.lowercased()
        return favoriteLocations.contains(locationLowerCased)
    }
    
    func saveFavoriteLocation(location: String) {
        let locationLowerCased = location.lowercased()
        var storedLocations = favoriteLocations
        if storedLocations.contains(locationLowerCased) {
            print("Already saved")
            return
        }
        storedLocations.append(locationLowerCased)
        store.storedWeatherLocations = storedLocations
    }
    
    func removeFavoriteLocation(location: String) {
        let locationLowerCased = location.lowercased()
        var storedLocations = favoriteLocations
        
        storedLocations.removeAll { $0 == locationLowerCased }
        store.storedWeatherLocations = storedLocations
    }
}
