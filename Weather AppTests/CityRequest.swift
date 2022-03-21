//
//  CityRequest.swift
//  Weather App
//
//  Created by Eric Davis on 21/03/2022.
//

import XCTest

@testable import Weather_App

class CityRequest: XCTestCase {
    
    var sut: CityAutocompleteRequest!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = CityAutocompleteRequest(cityPrefix: "oslo")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCityAutoCompleteRequest() {
        //given
        let promise = expectation(description: "Complete handle invoked")
        
        //when
        sut.send { response in
            switch response {
            case .success(let cities):
                promise.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [promise], timeout: 5)
    }

}
