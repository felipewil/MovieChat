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
        let comment = Comment(json: json)
        
        // Then
        XCTAssertEqual(comment.content, "Some_content")
    }
    
    func testModelShouldBeMappedToJson() {
        // Given
        var comment = Comment(content: "comment")
        comment.user = User(name: "name")
        
        // When
        let json = comment.toJSON()
        
        // Then
        XCTAssertEqual(json["content"] as! String, "comment")
        
        let userJson = json["user"] as! [ String: String ]
        XCTAssertEqual(userJson["name"], "name")
    }

}
