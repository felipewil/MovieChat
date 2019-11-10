//
//  ServicesManagerTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import MovieChat

class ServicesManagerTests: XCTestCase {

    var manager: ServicesManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        manager = .defaultManager()
    }

    override func tearDown() {
        manager = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMoviesJsonResponseShouldBeASuccess() {
        // Given
        let expectation = self.expectation(description: "Movies should be request successfully")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return request.url?.host == "tender-mclean-00a2bd.netlify.com"
        }) { _ -> OHHTTPStubsResponse in
            let json = [[ "title": "some_title" ],
                        [ "title": "some_title2" ]]
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        // When
        manager.requestMovies { success, movies in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(movies!.count, 2)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Movies not requested successfully")
            OHHTTPStubs.removeAllStubs()
        }
    }
    
    func testWrongDataResponseShouldBeAFailure() {
        // Given
        let expectation = self.expectation(description: "Movies should be request successfully")
        
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            return request.url?.host == "tender-mclean-00a2bd.netlify.com"
        }) { _ -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data: "some_data".data(using: .utf8)!, statusCode: 200, headers: nil)
        }
        
        // When
        manager.requestMovies { success, movies in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(movies)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Movies not requested successfully")
            OHHTTPStubs.removeAllStubs()
        }
    }

}
