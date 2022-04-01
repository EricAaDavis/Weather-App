//
//  FavouriteLocationsMapViewController.swift
//  Weather App
//
//  Created by Eric Davis on 28/03/2022.
//

import UIKit
import CoreLocation
import MapKit

protocol FavouriteLocationsMapViewControllerDelegate: AnyObject {
    func cellHeightExpanded()
    func cellHeightCollapsed()
}

class FavouriteLocationsMapViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate, FavouriteLocationsDelegateMap {
    
    weak var delegate: FavouriteLocationsMapViewControllerDelegate?

    @IBOutlet weak var favouriteLocationsMapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<String, Weather>
    
    var snapshot = NSDiffableDataSourceSnapshot<String, Weather>()
    var dataSource: DataSourceType!
    var currentIndexPath: IndexPath
    let viewModel: FavoriteLocationsViewModel
    
    var weatherLocations: [Weather] {
        viewModel.model.weatherLocations.sorted { lhs, rhs in
            lhs.cityName < rhs.cityName
        }
    }
    var currentlyDisplayedLocation: Weather? {
        didSet {
            showNewLocationOnMap(location: self.currentlyDisplayedLocation!)
        }
    }
    
    var cellIsExpanded = false
    var collectionViewHeight: CGFloat!
    var collectionViewHeightToSet: CGFloat {
        let safeAreaTop = view.safeAreaInsets.top
        let safeAreaBottom = view.safeAreaInsets.bottom
        return (view.frame.height - ( safeAreaTop + safeAreaBottom ))
    }
    
    init?(coder: NSCoder, viewModel: FavoriteLocationsViewModel, currentIndexPath: IndexPath) {
        self.viewModel = viewModel
        self.currentIndexPath = currentIndexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAnnotations(for: weatherLocations)
        
        viewModel.delegateMap = self
        collectionView.delegate = self
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getWeatherForStoredLocations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionViewHeight == nil {
            self.collectionViewHeightConstraint.constant = self.collectionViewHeightToSet * 0.25
            collectionViewHeight = collectionView.frame.height
        }
    }
    
    func showNewLocationOnMap(location: Weather) {
        let offset: Float = 0.2
        let regionToDisplay = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(location.coordinate.lat - offset), longitude: CLLocationDegrees(location.coordinate.lon)), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
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
        print(weatherLocations)
        snapshot.appendItems(weatherLocations)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            
            if !(self.cellIsExpanded){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.mapCellReuseIdentifier, for: indexPath) as! FavouriteLocationCollectionViewCell
                
                cell.setupCell(
                    location: item.cityName,
                    temperature: item.condition.temp,
                    description: item.weatherDescription[0].description,
                    weatherConditionID: item.weatherDescription[0].id)
            
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCollectionViewCell
                
                cell.setUpCell(for: item)
                return cell
            }
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 6
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: 0,
            trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            guard let self = self else { return }
            guard let indexPath = self.collectionView.centerIndexPath() else { return }
            self.currentlyDisplayedLocation = self.weatherLocations[indexPath.row]
            if self.currentIndexPath != indexPath {
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func centerIndexPath(point: CGPoint) -> IndexPath? {
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return nil }
        return indexPath
    }
    
    func itemsChanged() {
        updateCollectionView()
        collectionView.scrollToItem(at: currentIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !cellIsExpanded {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.delegate?.cellHeightExpanded()
                print("1 \(self.collectionViewHeightConstraint.constant)")
                self.collectionViewHeightConstraint.constant = self.collectionViewHeightToSet * 0.9
                print("2 \(self.collectionViewHeightConstraint.constant)")
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.cellIsExpanded.toggle()
                collectionView.reloadData()
            }
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.delegate?.cellHeightCollapsed()
                self.collectionViewHeightConstraint.constant = self.collectionViewHeightToSet * 0.25
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.cellIsExpanded.toggle()
                collectionView.reloadData()
            }
        }
        
    }
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
