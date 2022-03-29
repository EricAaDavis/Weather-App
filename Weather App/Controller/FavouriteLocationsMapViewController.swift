//
//  FavouriteLocationsMapViewController.swift
//  Weather App
//
//  Created by Eric Davis on 28/03/2022.
//

import UIKit
import CoreLocation
import MapKit

class FavouriteLocationsMapViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var favouriteLocationsMapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<String, Weather>
    
    var snapshot = NSDiffableDataSourceSnapshot<String, Weather>()
    var dataSource: DataSourceType!
    var currentIndexPath: IndexPath = .init(index: 0)
    
    let weatherLocations: [Weather]
    var currentlyDisplayedLocation: Weather? {
        didSet {
            showNewLocationOnMap(location: self.currentlyDisplayedLocation!)
        }
    }
    
    init?(coder: NSCoder, weatherLocations: [Weather]) {
        self.weatherLocations = weatherLocations
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createAnnotations(for: weatherLocations)
        
        
        collectionView.delegate = self
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        updateCollectionView()
    }
    
    func showNewLocationOnMap(location: Weather) {
//        self.favouriteLocationsMapView.se
        let regionToDisplay = MKCoordinateRegion(center:
                                                    CLLocationCoordinate2D(
                                                        latitude: CLLocationDegrees(location.coordinate.lat),
                                                        longitude: CLLocationDegrees(location.coordinate.lon)),
                                                 span: MKCoordinateSpan(
                                                    latitudeDelta: 2,
                                                    longitudeDelta: 2)
        )
        favouriteLocationsMapView.setRegion(regionToDisplay, animated: true)
    }
    
    func createAnnotations(for favoriteLocations: [Weather]) {
        favoriteLocations.forEach { location in
            let annotations = MKPointAnnotation()
            annotations.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.coordinate.lat), longitude: CLLocationDegrees(location.coordinate.lon))
            favouriteLocationsMapView.addAnnotation(annotations)
        }
    }
    
    func updateCollectionView() {
        snapshot.deleteAllItems()
        snapshot.appendSections(["Locations"])
        snapshot.appendItems(weatherLocations)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.mapCellReuseIdentifier, for: indexPath) as! MapCollectionViewCell
            
            cell.cityLabel.text = item.cityName
        
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
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
//            print(visibleItems.map {$0.indexPath.row} )
//            print(point)
            guard let self = self else {return}
            guard let indexPath = self.collectionView.centerIndexPath() else {return}
            
            if self.currentIndexPath != indexPath {
                self.currentlyDisplayedLocation = self.weatherLocations[indexPath.row]
            }
            
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func centerIndexPath(point: CGPoint) -> IndexPath? {
        guard
//            let point = collectionView.superview?.convert(point, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: point)
        else {
            return nil
        }
        return indexPath
    }

    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        var index: Int {
            if indexPath.row == 0 {
                return 0
            } else {
                return indexPath.row - 1
            }
        }
        
//        print("\(indexPath.row), \(index)")
//        T(weatherLocations[indexPath.row].cityName)
        currentlyDisplayedLocation = weatherLocations[indexPath.row]
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells
//        print(visibleCells)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("Did end dragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Did scroll")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UICollectionView {
    func centerIndexPath() -> IndexPath? {
        guard
            let point = superview?.convert(center, to: self),
            let indexPath = indexPathForItem(at: point)
        else {
            return nil
        }
        return indexPath
    }

    func sideCells() -> (UICollectionViewCell?, UICollectionViewCell?) {
        guard let indexPath = centerIndexPath() else {
            return (nil, nil)
        }

        let leftCell = cellForItem(at: IndexPath(item: indexPath.item-1, section: indexPath.section))
        let rightCell = cellForItem(at: IndexPath(item: indexPath.item+1, section: indexPath.section))

        return (leftCell, rightCell)
    }
}
