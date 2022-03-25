//
//  WeatherStore.swift
//  Weather App
//
//  Created by Eric Davis on 25/03/2022.
//

import Foundation

typealias FavoriteLocations = [String]

final class WeatherStore {
    
    static let shared = WeatherStore()
    
    private let store: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Key: String {
        case favoriteLocations
    }
    
    private init(store: UserDefaults = UserDefaults(suiteName: "WeatherStore")!) {
        self.store = store
    }
    
    var storedWeatherLocations: FavoriteLocations {
        get { retrieve(for: .favoriteLocations) ?? []}
        set { store(newValue, for: .favoriteLocations) }
    }
    
    //MARK: - Store Helper
    
    private func store<T: Encodable>(_ object: T?, for key: Key) {
        guard let object = object else {
            store.removeObject(forKey: key.rawValue)
            return
        }
        
        guard let encodedObject = try? encoder.encode(object) else {
            print("Can't encode object with type: '\(object.self)")
            return
        }
        store.set(encodedObject, forKey: key.rawValue)
    }
    
    private func retrieve<T: Decodable>(for key: Key) -> T? {
        guard let savedObject = store.data(forKey: key.rawValue),
              let object = try? decoder.decode(T.self, from: savedObject) else {
            return nil
        }
        return object
    }
    
}
