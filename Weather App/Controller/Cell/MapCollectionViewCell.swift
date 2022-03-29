//
//  MapCollectionViewCell.swift
//  Weather App
//
//  Created by Eric Davis on 29/03/2022.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
    }
    
}
