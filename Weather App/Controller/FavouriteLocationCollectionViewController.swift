//
//  FavouriteLocationCollectionViewController.swift
//  Weather App
//
//  Created by Eric Davis on 28/03/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavouriteLocationCollectionViewController: UICollectionViewController, FavoriteLocationsDelegate {

    typealias DataSourceType = UICollectionViewDiffableDataSource<String, Weather>
    
    var snapshot = NSDiffableDataSourceSnapshot<String, Weather>()
    var dataSource: DataSourceType!
    let viewModel = FavoriteLocationsViewModel()
    let favouriteLocationManager = FavouriteLocationsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        viewModel.delegate = self

        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getWeatherForStoredLocations()
    }
    
    func updateCollectionView() {
        let savedWeatherLocations = viewModel.model.weatherLocations.sorted { lhs, rhs in
            lhs.cityName < rhs.cityName
        }
        print(savedWeatherLocations)
        
        snapshot.deleteAllItems()
        snapshot.appendSections(["favourite locations"])
        snapshot.appendItems(savedWeatherLocations)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.savedLocationCellReuseIdentifier, for: indexPath) as! FavouriteLocationCollectionViewCell
            
            let location = item.cityName
            let temperature = item.condition.temp
            let description = item.weatherDescription[0].description
            let weatherCondition = item.weatherDescription[0].id
            
            cell.setupCell(
                location: location,
                temperature: temperature,
                description: description,
                weatherConditionID: weatherCondition)
            
            return cell
            
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.13)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
            
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func itemsChanged() {
        updateCollectionView()
    }
    
    @IBAction func test(_ sender: UIBarButtonItem) {
        print("These are the locations \(viewModel.model.weatherLocations)")
        print("Test")
        let storyboard = UIStoryboard(name: "FavouriteLocationsMap", bundle: nil)
        
        
        let favouriteLocationsMapView = storyboard.instantiateViewController(identifier: "FavouriteLocationsMapVC", creator: {coder in
            let sortedWeatherLocations = self.viewModel.model.weatherLocations.sorted(by: { lhs, rhs in
                lhs.cityName < rhs.cityName
            })
           return FavouriteLocationsMapViewController(coder: coder, weatherLocations: sortedWeatherLocations)
        })
        self.navigationController?.pushViewController(favouriteLocationsMapView, animated: true)
        
                                                                    
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration (identifier: nil, previewProvider: nil) { _ in
            let item = self.dataSource.itemIdentifier(for: indexPath)!
            let removeToggle = UIAction(title: "Un-favourite location") { (action) in
                let locationName = item.cityName.lowercased()
                self.favouriteLocationManager.removeFavoriteLocation(location: locationName)
                self.viewModel.getWeatherForStoredLocations()
            }
            return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: [], children: [removeToggle])
        }
        return config
    }
}


class QuickVc: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
