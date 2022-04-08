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
                
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func setupCell(location: String, temperature: Float, description: String, weatherConditionID: Int) {
       
        locationLabel.text = location
        temperatureLabel.text = "\(preciseRound(temperature, precision: .tenths)) C˚"
        descriptionLabel.text = description
        
        let weatherConditionSymbolName = ForecastViewModel.weatherConditionSymbol(for: weatherConditionID)
        weatherConditionSymbolImageView.image = UIImage(systemName: weatherConditionSymbolName)
        
        let weatherConditionImageName = ForecastViewModel.weatherConditionImage(for: weatherConditionID)
        weatherConditionImageView.image = UIImage(named: weatherConditionImageName)
    }
    
    
    
    func cellHeightExpanded() {
        print("Cell height expanded")
    }
    
    func cellHeightCollapsed() {
        print("cell height collapsed")
    }
}
