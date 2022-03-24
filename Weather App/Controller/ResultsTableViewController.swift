//
//  ResultsTableViewController.swift
//  Weather App
//
//  Created by Eric Davis on 23/03/2022.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var viewModel: ForecastViewModel
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel2 = ForecastViewModel()
    
    //TODO: What is going on here?
    init?(coder: NSCoder, viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }

    // MARK: - Table view data source
    
    var dataSource: [String] = [] {
        didSet {
            activityIndicator.stopAnimating()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityAndCountry = dataSource[indexPath.row].components(separatedBy: ", ")
        let city = cityAndCountry[0].lowercased()
        viewModel.getWeatherFor(location: city)
    }
}
