//
//  SearchWeatherViewController.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import UIKit
import CoreLocation
import MapKit

class ForecastWeatherViewController: UIViewController, UISearchResultsUpdating, ForecastViewModelDelegate  {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var weatherConditionView: UIView!
    
    let locationManager = CLLocationManager()
    
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
        
        weatherConditionView.layer.cornerRadius = 10
        
        viewModel.delegate = self
        viewModel.getWeatherFor(location: "oslo")
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
        descriptionLabel.text = weather.weatherDescription[0].description
        
        currentTemperatureLabel.text = "Current \(weather.condition.temp)C˚ | Min \(weather.condition.temp_min) C˚ | Max \(weather.condition.temp_max) C˚"
        feelsLikeTemperatureLabel.text = "\(weather.condition.feels_like) C˚"
        
        humidityLabel.text = "\(weather.condition.humidity)%"
        pressureLabel.text = "\(weather.condition.pressure)"
        let conditionImageName = viewModel.weatherImage(for: weather.weatherDescription[0].id)
        print(conditionImageName)
        weatherConditionImage.image = UIImage(systemName: conditionImageName)
    }
    
    func weatherFetched() {
        if let weather = viewModel.fetchedWeather {
            updateUI(for: weather)
        }
    }
    //TODO: put these two functions in a view model file or manager.
//    getWeatherFor(coordinate:)
    
    @IBAction func getCurrentLocationTapped(_ sender: UIBarButtonItem) {
        print("Current location")
    }
    
}

extension ForecastWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude), \(locValue.longitude)")
        
    }
}
