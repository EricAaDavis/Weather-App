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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Location"
        navigationItem.searchController = search
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
        updateUI(location: "oslo")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let locationText = searchController.searchBar.text
        
        if let locationText = locationText {
            updateUI(location: locationText.lowercased())
        }
    }
    
    func updateUI(location: String) {
        WeatherRequest(location: location).send { response in
            switch response {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.navigationItem.title = weather.cityName
                    self.temperatureLabel.text = "\(weather.condition.temp)"
                    self.humidityLabel.text = "\(weather.condition.humidity)%"
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
