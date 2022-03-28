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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        viewModel.delegate = self
        
        // Do any additional setup after loading the view.
//        collectionView.delegate = self
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
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
        let spacing: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.14)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
