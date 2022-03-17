//
//  SearchWeatherViewController.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import UIKit

class ForecastWeatherViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Location"
        navigationItem.searchController = searchController
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        getWeatherFor(location: "oslo")
    }
    
    @objc func dismissKeyboard() {
//        searchController.searchBar.endEditing(true)
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let locationText = searchController.searchBar.text
        
        if let locationText = locationText {
            getWeatherFor(location: locationText.lowercased())
        }
    }
    
    
    
    func updateUI(weather: Weather) {
        temperatureLabel.text = "\(weather.condition.temp) C˚"
        humidityLabel.text = "\(weather.condition.humidity)%"
        
    }
    
    //TODO: put these two functions in a view model file or manager.
//    getWeatherFor(coordinate:)
    
    func getWeatherFor(location: String) {
        WeatherRequest(location: location).send { response in
            switch response {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.updateUI(weather: weather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    

        
}

