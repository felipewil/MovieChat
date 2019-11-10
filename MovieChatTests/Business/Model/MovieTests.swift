//
//  MovieTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

class MovieTests: XCTestCase {

    func testModelShouldBeInitializedWithJSON() {
        // Given
        let json = [
            "title": "Some_title",
            "director": "Some_director",
            "year": "Some_year",
            "runtime": "Some_runtime"
        ]
        
        // When
        let movie = Movie(json: json)
        
        // Then
        XCTAssertEqual(movie.title, "Some_title")
        XCTAssertEqual(movie.director, "Some_director")
        XCTAssertEqual(movie.year, "Some_year")
        XCTAssertEqual(movie.runtime, "Some_runtime")
    }

}
