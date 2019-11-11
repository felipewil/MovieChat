//
//  WelcomeVCTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class WelcomePresenterMock : WelcomePresenter {
    
    var delegateDidUpdateNameCalls = 0
    var delegateDidUpdateNameLastValue: String!
    override func delegateDidUpdateName(_ name: String) {
        delegateDidUpdateNameCalls += 1
        delegateDidUpdateNameLastValue = name
    }
    
    var delegateDidEnterCalls = 0
    override func delegateDidEnter(withName name: String) {
        delegateDidEnterCalls += 1
    }
    
}

private class WelcomeVCMock : WelcomeVC {
    
    var performSegueCalls = 0
    var performSegueLastIdentifier: String!
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        performSegueCalls += 1
        performSegueLastIdentifier = identifier
    }
    
    var enterButtonTappedCalls = 0
    override func enterButtonTapped() {
        enterButtonTappedCalls += 1
        super.enterButtonTapped()
    }
    
}

class WelcomeVCTests: XCTestCase {

    var viewController: WelcomeVC!
    private var presenterMock: WelcomePresenterMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenterMock = WelcomePresenterMock(loginManager: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC
        viewController.presenter = presenterMock
        
        // Initialize and test view at the same time
        XCTAssertNotNil(viewController.view)
    }

    override func tearDown() {
        viewController = nil
        presenterMock = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Actions tests

    func testTextFieldEditingChanagedShouldWarnPresenter() {
        // Given
        let textField = UITextField(frame: .zero)
        textField.text = "some_text"
        
        // When
        viewController.editingChanged(textField)
        
        // Then
        XCTAssertEqual(presenterMock.delegateDidUpdateNameCalls, 1)
        XCTAssertEqual(presenterMock.delegateDidUpdateNameLastValue, "some_text")
    }
    
    func testEnterButtonTappedShouldWarnPresenter() {
        // Given
        // Initial state
        
        // When
        viewController.enterButtonTapped()
        
        // Then
        XCTAssertEqual(presenterMock.delegateDidEnterCalls, 1)
    }
    
    func testEnterButtonTappedShouldSegueToMovieList() {
        // Given
        let textField = UITextField(frame: .zero)
        let viewController = WelcomeVCMock()
        viewController.presenter = presenterMock
        viewController.nameTextField = textField
                
        // When
        viewController.enterButtonTapped()
        
        // Then
        XCTAssertEqual(viewController.performSegueCalls, 1)
        XCTAssertEqual(viewController.performSegueLastIdentifier, "MovieListSegue")
    }
    
    // MARK: - WelcomePresenterDelegate tests
    
    func testEnableEnterShouldEnableEnterButton() {
        // Given
        viewController.enterButton.isEnabled = false
        
        // When
        viewController.enableEnter(true)
        
        // Then
        XCTAssertTrue(viewController.enterButton.isEnabled)
        
        // When
        viewController.enableEnter(false)
        
        // Then
        XCTAssertFalse(viewController.enterButton.isEnabled)
    }
    
    // MARK: - UITextFieldDelegate
    
    func testTextFieldReturnShouldCallButtonTapIfButtonIsEnabled() {
        // Given
        let viewController = WelcomeVCMock()
        let textField = UITextField(frame: .zero)
        let button = UIButton(frame: .zero)
        button.isEnabled = true
        
        viewController.nameTextField = textField
        viewController.presenter = presenterMock
        viewController.enterButton = button
        
        // When
        _ = viewController.textFieldShouldReturn(textField)
        
        // Then
        XCTAssertEqual(viewController.enterButtonTappedCalls, 1)
    }
    
    func testTextFieldReturnShouldNotCallButtonTapIfButtonIsDisabled() {
        // Given
        let viewController = WelcomeVCMock()
        let textField = UITextField(frame: .zero)
        let button = UIButton(frame: .zero)
        button.isEnabled = false
        
        viewController.enterButton = button
        
        // When
        _ = viewController.textFieldShouldReturn(textField)
        
        // Then
        XCTAssertEqual(viewController.enterButtonTappedCalls, 0)
    }

}
