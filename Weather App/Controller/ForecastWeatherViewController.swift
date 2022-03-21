//
//  SearchWeatherViewController.swift
//  Weather App
//
//  Created by Eric Davis on 17/03/2022.
//

import UIKit
import CoreLocation
import MapKit
import Combine

class ForecastWeatherViewController: UIViewController, UISearchResultsUpdating  {
    
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
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscription()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Location"
        navigationItem.searchController = searchController
    
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        weatherConditionView.layer.cornerRadius = 10
    }
    
    private func setupSubscription() {
        viewModel.$fetchedWeather
            .filter { $0 != nil }
            .receive(on: DispatchQueue.main)
            .sink { self.updateUI(for: $0!) }
            .store(in: &cancellables)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let selector = #selector(fetchWeatherForLocation)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
        
        perform(selector, with: nil, afterDelay: 0.3)
    }
    
    @objc func fetchWeatherForLocation() {
        let locationText = searchController.searchBar.text
        if let locationText = locationText {
            let urlString = locationText.lowercased()
                viewModel.getWeatherFor(location: urlString)
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
        weatherConditionImage.image = UIImage(systemName: conditionImageName)
    }
    
    func weatherFetched() {
        if let weather = viewModel.fetchedWeather {
            updateUI(for: weather)
        }
    }
    
    @IBAction func getWeatherForLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}

extension ForecastWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.getWeatherFor(lat: String(locValue.latitude), lon: String(locValue.longitude))
        locationManager.stopUpdatingLocation()
    }
}
