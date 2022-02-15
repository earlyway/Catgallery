//
//  catCrawlerTests.swift
//  catCrawlerTests
//
//  Created by Mac pro on 2022/02/09.
//

import XCTest
@testable import catCrawler

class catCrawlerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCatCrawling() {
        
        let expection = XCTestExpectation(description: "Cat Crawling")
        
        let service = CatService()
        service.getCats(page: 0, limit: 0) { result in
            switch result {
            case .failure(let error):
                expection.fulfill()
            case .success(let response):
                print(response)
                expection.fulfill()
            }
        }
        
        wait(for: [expection], timeout: 10.0)
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
