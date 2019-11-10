//
//  WelcomePresenterTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class WelcomePresenterDelegateMock : WelcomePresenterDelegate {
    
    var enableEnterCalls = 0
    var enableEnterLastValue: Bool!
    func enableEnter(_ enable: Bool) {
        enableEnterCalls += 1
        enableEnterLastValue = enable
    }
    
}

class WelcomePresenterTests: XCTestCase {

    func testEnterShouldBeEnabledIfNameIsThreOrMoreCharacters() {
        // Given
        let delegateMock = WelcomePresenterDelegateMock()
        let presenter = WelcomePresenter()
        presenter.delegate = delegateMock
        
        // When
        presenter.delegateDidUpdateName("")
        
        // Then
        XCTAssertEqual(delegateMock.enableEnterCalls, 1)
        XCTAssertFalse(delegateMock.enableEnterLastValue)
        
        // When
        presenter.delegateDidUpdateName("na")
        
        // Then
        XCTAssertEqual(delegateMock.enableEnterCalls, 2)
        XCTAssertFalse(delegateMock.enableEnterLastValue)
        
        // When
        presenter.delegateDidUpdateName("nam")
        
        // Then
        XCTAssertEqual(delegateMock.enableEnterCalls, 3)
        XCTAssertTrue(delegateMock.enableEnterLastValue)
    }

}
