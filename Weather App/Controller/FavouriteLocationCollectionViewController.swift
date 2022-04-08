//
//  FavouriteLocationCollectionViewController.swift
//  Weather App
//
//  Created by Eric Davis on 28/03/2022.
//

import UIKit

class FavouriteLocationCollectionViewController: UICollectionViewController, FavoriteLocationsDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getWeatherForStoredLocations()
    }
    
    func updateCollectionView() {
        activityIndicator.stopAnimating()
        let savedWeatherLocations = viewModel.model.weatherLocations.sorted { lhs, rhs in
            lhs.cityName < rhs.cityName
        }
        
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
            
            let imageName = ForecastViewModel.weatherConditionImage(for: weatherCondition)
            cell.weatherConditionImageView.image = UIImage(named: imageName)
            
            return cell
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 15
        
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
    
    func pushMapViewController(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "FavouriteLocationsMap", bundle: nil)
        let favouriteLocationsMapView = storyboard.instantiateViewController(identifier: "FavouriteLocationsMapVC", creator: {coder in
            return FavouriteLocationsMapViewController(coder: coder, viewModel: self.viewModel, currentIndexPath: indexPath)
        })
        self.navigationController?.pushViewController(favouriteLocationsMapView, animated: true)
    }
    
    func itemsChanged() {
        updateCollectionView()
    }
    
    @IBAction func showMapView(_ sender: UIBarButtonItem) {
        let defaultIndexPath: IndexPath = IndexPath(row: 0, section: 0)
        pushMapViewController(indexPath: defaultIndexPath)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushMapViewController(indexPath: indexPath)
    }
    
}
