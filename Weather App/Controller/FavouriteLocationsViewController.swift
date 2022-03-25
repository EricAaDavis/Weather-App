//
//  FavouriteLocationsViewController.swift
//  Weather App
//
//  Created by Eric Davis on 24/03/2022.
//

import UIKit

class FavouriteLocationsViewController: UIViewController, UICollectionViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<String, Weather>
    
    var snapshot = NSDiffableDataSourceSnapshot<String, Weather>()
    var dataSource: DataSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.savedLocationCellReuseIdentifier, for: indexPath) as! FavouriteLocationCollectionViewCell
            
            let location = item.cityName
            let temperature = item.condition.temp
            let description = item.weatherDescription[0].description
            let weatherCondition = item.weatherDescription[0].id
            
            cell.layer.cornerRadius = 20
            
            cell.setupCell(
                location: location,
                temperature: temperature,
                description: description,
                weatherConditionID: weatherCondition)
            
            return cell
            
        }
        return dataSource
    }
    
}
