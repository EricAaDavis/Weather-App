//
//  FavouriteLocationCollectionViewCell.swift
//  Weather App
//
//  Created by Eric Davis on 24/03/2022.
//

import UIKit

class FavouriteLocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    func setupCell(location: String, temperature: Float, description: String, weatherConditionID: Int) {
        
        locationLabel.text = location
        temperatureLabel.text = "\(preciseRound(temperature, precision: .tenths)) C"
        descriptionLabel.text = description
        
        let weatherConditionID = ForecastViewModel.weatherImage(for: weatherConditionID)
        
        weatherConditionImageView.image = UIImage(systemName: weatherConditionID)
    }
}
