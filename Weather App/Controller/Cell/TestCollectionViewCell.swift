//
//  TestCollectionViewCell.swift
//  Weather App
//
//  Created by Eric Davis on 01/04/2022.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionSymbolImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreesLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var detailedWeatherDataView: UIView!
    
    
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
    
    func setUpCell(for weather: Weather){
        detailedWeatherDataView.alpha = 0
        let weatherConditionImageName = ForecastViewModel.weatherConditionImage(for: weather.weatherDescription[0].id)
        weatherConditionImage.image = UIImage(named: weatherConditionImageName)
        cityNameLabel.text = weather.cityName
        
        let currentTemperatureRounded = preciseRound(weather.condition.temp, precision: .tenths)
        currentTemperatureLabel.text = "\(currentTemperatureRounded) C˚"
        
        let weatherConditionSymbolName = ForecastViewModel.weatherConditionSymbol(for: weather.weatherDescription[0].id)
        weatherConditionSymbolImage.image = UIImage(systemName: weatherConditionSymbolName)
        
        descriptionLabel.text = weather.weatherDescription[0].description
        
        let maxTempRounded = preciseRound(weather.condition.temp_max, precision: .tenths)
        let minTempRounded = preciseRound(weather.condition.temp_min, precision: .tenths)
        let feelsLikeTempRounded = preciseRound(weather.condition.feels_like, precision: .tenths)
        maxTempLabel.text = "Max \(maxTempRounded) C˚"
        minTempLabel.text = "Min \(minTempRounded) C˚"
        feelsLikeTemperatureLabel.text = "\(feelsLikeTempRounded) C˚"
        
        windSpeedLabel.text = "\(weather.wind.speed) m/s"
        windDegreesLabel.text = "\(weather.wind.deg)˚"
        
        humidityLabel.text = "\(weather.condition.humidity)%"
        
        pressureLabel.text = "\(weather.condition.pressure)hPa"
    }
    
    func animateOnAppear() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut) {
            self.detailedWeatherDataView.alpha = 1
        } completion: { _ in}

    }
    
}
