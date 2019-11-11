//
//  CommentTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

class CommentTests: XCTestCase {

    func testModelShouldBeInitializedWithJSON() {
        // Given
        let json = [ "content": "Some_content" ]
        
        // When
        let movie = Comment(json: json)
        
        // Then
        XCTAssertEqual(movie.content, "Some_content")
    }

}
