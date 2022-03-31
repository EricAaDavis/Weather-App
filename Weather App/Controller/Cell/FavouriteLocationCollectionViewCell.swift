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
    @IBOutlet weak var weatherConditionSymbolImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
    func setupCell(location: String, temperature: Float, description: String, weatherConditionID: Int) {
        
        locationLabel.text = location
        temperatureLabel.text = "\(preciseRound(temperature, precision: .tenths)) C"
        descriptionLabel.text = description
        
        let weatherConditionSymbolName = ForecastViewModel.weatherConditionSymbol(for: weatherConditionID)
        weatherConditionSymbolImageView.image = UIImage(systemName: weatherConditionSymbolName)
        
        let weatherConditionImageName = ForecastViewModel.weatherConditionImage(for: weatherConditionID)
        weatherConditionImageView.image = UIImage(named: weatherConditionImageName)
    }
}
