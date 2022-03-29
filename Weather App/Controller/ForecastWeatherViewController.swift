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
    @IBOutlet weak var getWeatherForCoordinateButton: UIBarButtonItem!
    @IBOutlet weak var weatherDataStackView: UIStackView!
    @IBOutlet weak var favouriteLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var searchController: UISearchController!
    var resultViewController: ResultsTableViewController!
    var viewModel = ForecastViewModel()
    var favouriteLocationsManager = FavouriteLocationsManager()
    var cityName: String!
    var favouriteLocationState: Bool {
        favouriteLocationsManager.containsFavoriteLocation(location: cityName)
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscription()
        
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        resultViewController = storyboard.instantiateViewController(identifier: "resultsVC", creator: { coder in
            ResultsTableViewController(coder: coder, viewModel: self.viewModel)
        })
        
        weatherDataStackView.alpha = 0
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
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
            resultViewController.activityIndicator.startAnimating()
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
        displayWeatherData()
        searchController.searchResultsController?.dismiss(animated: true)
        searchController.searchBar.text = nil
        
        if viewModel.requestType == .coordinate {
            fillLocationButton()
        } else if viewModel.requestType == .locationName {
            getWeatherForCoordinateButton.image = UIImage(systemName: "location")
        }
        
        self.title = "\(weather.cityName), \(weather.sys.country.lowercased())"
        descriptionLabel.text = weather.weatherDescription[0].description
        
        let currentTempRounded = preciseRound(weather.condition.temp, precision: .tenths)
        let minTempRounded = preciseRound(weather.condition.temp_min, precision: .tenths)
        let maxTempRounded = preciseRound(weather.condition.temp_max, precision: .tenths)
        currentTemperatureLabel.text = "Current \(currentTempRounded) C˚ | Min \(minTempRounded) C˚ | Max \(maxTempRounded) C˚"
        
        let feelsLikeRounded = preciseRound(weather.condition.feels_like, precision: .ones)
        feelsLikeTemperatureLabel.text = "\(String(format: "%.0f", feelsLikeRounded)) C˚"
        
        humidityLabel.text = "\(weather.condition.humidity)%"
        pressureLabel.text = "\(weather.condition.pressure) hPa"
        
        let conditionImageName = ForecastViewModel.weatherImage(for: weather.weatherDescription[0].id)
        weatherConditionImage.image = UIImage(systemName: conditionImageName)
        
        cityName = weather.cityName
        toggleButtonAppearance(isFavorite: favouriteLocationState)
    }
    
    func displayWeatherData() {
        weatherDataStackView.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            self.weatherDataStackView.alpha = 1
        } completion: { _ in }
    }
    
    func fillLocationButton() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.getWeatherForCoordinateButton.image = UIImage(systemName: "location.fill")
        } completion: { _ in }
    }
    
    func toggleButtonAppearance(isFavorite: Bool) {
        if isFavorite {
            self.favouriteLocationButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.favouriteLocationButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    @IBAction func favourizeLocationButtonTapped(_ sender: UIButton) {
        if !favouriteLocationState {
            favouriteLocationsManager.saveFavoriteLocation(location: cityName)
        } else {
            favouriteLocationsManager.removeFavoriteLocation(location: cityName)
        }
        toggleButtonAppearance(isFavorite: favouriteLocationState)
    }
    
    @IBAction func getWeatherForCoordinateTapped(_ sender: Any) {
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
