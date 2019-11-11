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

private class LoginManagerMock : LoginManager {
    
    var setCurrentUserCalls = 0
    var setCurrentUserLastValue: User!
    override func setCurrentUser(_ user: User) {
        setCurrentUserCalls += 1
        setCurrentUserLastValue = user
    }
    
}

class WelcomePresenterTests: XCTestCase {

    var presenter: WelcomePresenter!
    private var delegateMock: WelcomePresenterDelegateMock!
    private var loginManagerMock: LoginManagerMock!
    
    override func setUp() {
        super.setUp()
        
        delegateMock = WelcomePresenterDelegateMock()
        loginManagerMock = LoginManagerMock(userDefaults: nil)
        
        presenter = WelcomePresenter(loginManager: loginManagerMock)
        presenter.delegate = delegateMock
    }
    
    override func tearDown() {
        presenter = nil
        delegateMock = nil
        
        super.tearDown()
    }
    
    // MARK: - Delegate methods tests
    
    func testEnterShouldBeEnabledIfNameIsThreOrMoreCharacters() {
        // Given
        // Initial state
        
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
    
    func testDelegateDidEnterShouldSaveUser() {
        // Given
        // Initial state
        
        // When
        presenter.delegateDidEnter(withName: "some_name")
        
        // Then
        XCTAssertEqual(loginManagerMock.setCurrentUserCalls, 1)
        XCTAssertEqual(loginManagerMock.setCurrentUserLastValue.name, "some_name")
    }

}
