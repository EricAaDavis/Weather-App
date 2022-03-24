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
    
    func setupCell(location: String, temperature: String, description: String, weatherConditionImage: String) {
        locationLabel.text = location
        temperatureLabel.text = temperature
        descriptionLabel.text = description
    }
}
