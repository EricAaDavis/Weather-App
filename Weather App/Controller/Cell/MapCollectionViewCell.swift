//
//  MapCollectionViewCell.swift
//  Weather App
//
//  Created by Eric Davis on 29/03/2022.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTemperatureLabel: UILabel!
    @IBOutlet weak var cityHumidityLabel: UILabel!
    @IBOutlet weak var cityWeatherDescription: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
}
