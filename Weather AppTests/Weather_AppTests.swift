//
//  Weather_AppTests.swift
//  Weather AppTests
//
//  Created by Eric Davis on 17/03/2022.
//

import XCTest

@testable import Weather_App

class Weather_AppTests: XCTestCase {
    
    var sut: WeatherRequest!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = WeatherRequest()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testCityWeatherRequest() {
        //given
        let promise = expectation(description: "Complete handle invoked")
        WeatherRequest().send { result in
            //when
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [promise], timeout: 5)
        
    }

}
