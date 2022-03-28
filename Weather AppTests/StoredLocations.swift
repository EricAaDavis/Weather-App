//
//  StoredLocations.swift
//  Weather AppTests
//
//  Created by Eric Davis on 25/03/2022.
//

import XCTest

@testable import Weather_App

class StoredLocations: XCTestCase {
    
    var sut: FavouriteLocationsManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = FavouriteLocationsManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        sut = nil
    }

    func testRetrievingLocations() {
        //given
        let savedLocations = ["oslo", "bergen", "new york"]
        
        //when
        savedLocations.forEach { sut.saveFavoriteLocation(location: $0) }
        
        //then
        XCTAssertTrue(sut.favoriteLocations.count == 3)
    }
    
    func testRemovingLocation() {
        //given
        let savedLocations = ["oslo", "bergen", "new york"]
        
        //when
        savedLocations.forEach { sut.saveFavoriteLocation(location: $0) }
        sut.removeFavoriteLocation(location: "oslo")
        
        XCTAssertTrue(sut.favoriteLocations.count == 2)
        print(sut.favoriteLocations)
        
    }
}
