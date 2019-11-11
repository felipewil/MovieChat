//
//  UserTests.swift
//  MovieChatTests
//
//  Created by Guiche Virtual on 11/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

class UserTests: XCTestCase {

    func testModelShouldBeInitializedWithJSON() {
        // Given
        let json = [ "name": "name" ]
        
        // When
        let user = User(json: json)
        
        // Then
        XCTAssertEqual(user.name, "name")
    }
    
    func testModelShouldBeInitializedWithName() {
        // Given
        // Initial state
        
        // When
        let user = User(name: "name")
        
        // Then
        XCTAssertEqual(user.name, "name")
    }
    
    func testModelShouldBeMappedToJson() {
        // Given
        let user = User(name: "name")
        
        // When
        let json = user.toJSON()
        
        // Then
        XCTAssertEqual(json["name"] as! String, "name")
    }

}
