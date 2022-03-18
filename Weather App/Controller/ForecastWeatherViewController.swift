//
//  SearchWeatherViewController.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import UIKit

class ForecastWeatherViewController: UIViewController, UISearchResultsUpdating, ForecastViewModelDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    let searchController = UISearchController()
    var viewModel = ForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Location"
        navigationItem.searchController = searchController
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        viewModel.delegate = self
        
        viewModel.getWeatherFor(location: "oslo")
    }
    
    @objc func dismissKeyboard() {
//        searchController.searchBar.endEditing(true)
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let locationText = searchController.searchBar.text
        
        if let locationText = locationText {
            viewModel.getWeatherFor(location: locationText.lowercased())
        }
    }
    
    func updateUI(for weather: Weather) {
        self.title = weather.cityName
        
//        temperatureLabel.text = "\(weather.condition.temp) C˚"
//        humidityLabel.text = "\(weather.condition.humidity)%"
        
        
    }
    
    func weatherFetched() {
        if let weather = viewModel.fetchedWeather {
            updateUI(for: weather)
        }
    }
    //TODO: put these two functions in a view model file or manager.
//    getWeatherFor(coordinate:)
}

