//
//  LoginManagerTests.swift
//  MovieChatTests
//
//  Created by Guiche Virtual on 11/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

class LoginManagerTests: XCTestCase {

    func testSaveAndRetrieveUser() {
        // Given
        let manager = LoginManager.defaultManager()
        let user = User(name: "name")
        
        // When
        manager.setCurrentUser(user)
        
        // Then
        XCTAssertEqual(manager.currentUser()?.name, "name")
    }
    

}
