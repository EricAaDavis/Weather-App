//
//  FavoriteLocationsViewModel.swift
//  Weather App
//
//  Created by Eric Davis on 25/03/2022.
//

import Foundation

protocol FavoriteLocationsDelegate: AnyObject {
    func itemsChanged()
}

final class FavoriteLocationsViewModel {
    
    weak var delegate: FavoriteLocationsDelegate?
    
    let favoriteLocationsManager = FavouriteLocationsManager()
    
    var model = Model()
    
    func getWeatherForStoredLocations() {
        let group = DispatchGroup()
        let storedLocations = favoriteLocationsManager.favoriteLocations
        for storedLocation in storedLocations {
            group.enter()
            WeatherRequestLocation(location: storedLocation).send { response in
                switch response {
                case .success(let weather):
                    self.model.weatherLocations.append(weather)
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.delegate?.itemsChanged()
        }
    }
}


struct Model {
    var weatherLocations: [Weather] = []
}
