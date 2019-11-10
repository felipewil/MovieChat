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
    
}

private class UINavigationControllerMock : UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers.append(viewController)
    }
    
}

private class WelcomeVCMock : WelcomeVC {
    
    var enterButtonTappedCalls = 0
    override func enterButtonTapped() {
        enterButtonTappedCalls += 1
    }
    
}

class WelcomeVCTests: XCTestCase {

    var viewController: WelcomeVC!
    private var presenterMock: WelcomePresenterMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenterMock = WelcomePresenterMock()
        
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
    
    func testEnterButtonTappedShouldSegueToMovieList() {
        // Given
        let navVC = UINavigationControllerMock(rootViewController: viewController)
        
        XCTAssertEqual(navVC.viewControllers.count, 1)
        
        // When
        viewController.enterButtonTapped()
        
        // Then
        XCTAssertEqual(navVC.viewControllers.count, 2)
        XCTAssertTrue(navVC.viewControllers.last! is MovieListVC)
        
        navVC.viewControllers = []
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
