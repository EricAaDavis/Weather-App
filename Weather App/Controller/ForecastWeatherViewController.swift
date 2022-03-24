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
    var resultViewController: ResultsTableViewController!
    var searchController: UISearchController!
    var viewModel = ForecastViewModel()
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscription()
        
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        resultViewController = storyboard.instantiateViewController(identifier: "resultsVC", creator: { coder in
            ResultsTableViewController(coder: coder, viewModel: self.viewModel)
        })
//        resultViewController = storyboard.instantiateViewController(withIdentifier: "resultsVC") as? ResultsTableViewController
        
        searchController = UISearchController(searchResultsController: resultViewController)
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
            .print()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                print("End of stream")
            }, receiveValue: { weather in
                guard let weather = weather else { return }
                self.updateUI(for: weather)
            })
            .store(in: &cancellables)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let selector = #selector(fetchWeatherForLocation)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
        
        perform(selector, with: nil, afterDelay: 0.3)
        
    }
    
    @objc func fetchWeatherForLocation() {
        guard let prefix = searchController.searchBar.text else { return }
        
        if prefix != "" {
            let prefixLowercased = prefix.lowercased()
            
            CityAutocompleteRequest(locationPrefix: prefixLowercased).send { response in
                switch response {
                case .success(let cities):
                    var newDatasource = [String]()
                    cities.cityData.forEach { newDatasource.append("\($0.name), \($0.country)") }
                    DispatchQueue.main.async {
                        self.resultViewController.dataSource  = newDatasource
                        self.resultViewController.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateUI(for weather: Weather) {
        searchController.searchResultsController?.dismiss(animated: true)
        searchController.searchBar.text = nil
        
        self.title = weather.cityName
        descriptionLabel.text = weather.weatherDescription[0].description
        currentTemperatureLabel.text = "Current \(weather.condition.temp)C˚ | Min \(weather.condition.temp_min) C˚ | Max \(weather.condition.temp_max) C˚"
        feelsLikeTemperatureLabel.text = "\(weather.condition.feels_like) C˚"
        humidityLabel.text = "\(weather.condition.humidity)%"
        pressureLabel.text = "\(weather.condition.pressure)"
        
        let conditionImageName = viewModel.weatherImage(for: weather.weatherDescription[0].id)
        weatherConditionImage.image = UIImage(systemName: conditionImageName)
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
