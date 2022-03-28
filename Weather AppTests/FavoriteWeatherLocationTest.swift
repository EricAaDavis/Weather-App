//
//  FavoriteWeatherLocationTest.swift
//  Weather AppTests
//
//  Created by Eric Davis on 25/03/2022.
//

import XCTest

@testable import Weather_App

class FavoriteWeatherLocationTest: XCTestCase, FavoriteLocationsDelegate {
   
    
    
    var sut: FavoriteLocationsViewModel!
    lazy var promise = expectation(description: "Complete handle invoked")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = FavoriteLocationsViewModel()
        sut.delegate = self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testFavoriteLocationsRequests() {
        //given
        let locations = ["oslo", "bergen", "new york", "amsterdam"]
        
        //when
        sut.getWeatherForStoredLocations(locations: locations)
        
        wait(for: [promise], timeout: 2)
    }
    
    func itemsChanged() {
        promise.fulfill()
    }

}
