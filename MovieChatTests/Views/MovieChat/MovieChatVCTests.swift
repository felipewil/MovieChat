//
//  MovieChatVCTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class MovieChatPresenterMock : MovieChatPresenter {
    
    var delegateDidLoadCalls = 0
    override func delegateDidLoad() {
        delegateDidLoadCalls += 1
    }
    
    var delegateWantsToSaveCommentCalls = 0
    override func delegateWantsToSaveComment(_ comment: String) {
        delegateWantsToSaveCommentCalls += 1
    }
    
    var numberOfCommentsCalls = 0
    override func numberOfComments() -> Int {
        numberOfCommentsCalls += 1
        return 0
    }
    
    var commentAtRowStub: Comment!
    var commentAtRowCalls = 0
    override func comment(atRow row: Int) -> Comment {
        commentAtRowCalls += 1
        return commentAtRowStub
    }
    
    override func isCommentFromCurrentUser(_ comment: Comment) -> Bool {
        return false
    }
    
}

class MovieChatVCTests: XCTestCase {

    var viewController: MovieChatVC!
    private var presenterMock: MovieChatPresenterMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let movie = Movie(json: [:])
        presenterMock = MovieChatPresenterMock(movie: movie,
                                               databaseManager: nil,
                                               loginManager: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "MovieChatVC") as? MovieChatVC
        viewController.presenter = presenterMock
        viewController.movie = movie
        
        // Initialize and test view at the same time
        XCTAssertNotNil(viewController.view)
    }

    override func tearDown() {
        viewController = nil
        presenterMock = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Life cycle tests
    
    func testViewDidLoadShouldWarnPresenter() {
        // Given
        presenterMock.delegateDidLoadCalls = 0
        
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertEqual(presenterMock.delegateDidLoadCalls, 1)
    }

    // MARK: - Action tests
    
    func testSubmitButtonTappedShouldWarnPresenter() {
        // Given
        // Initial state
        
        // When
        viewController.submitButtonTapped()
        
        // Then
        XCTAssertEqual(presenterMock.delegateWantsToSaveCommentCalls, 1)
    }
    
    // MARK: - UITableViewDataSource tests
    
    func testNumberOfRowsShouldAskPresenter() {
        // Given
        // Initial state
        
        // When
        _ = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(presenterMock.numberOfCommentsCalls, 1)
    }

    func testCellForRowShouldBeCommentCell() {
        // Given
        let comment = Comment(content: "")
        presenterMock.commentAtRowStub = comment
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Then
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertTrue(cell is CommentCell)
        XCTAssertEqual(presenterMock.commentAtRowCalls, 1)
    }
    
    // MARK: - UITextViewDelegate tests
    
    func testTextViewDidChangeShouldEnableSubmitButtonIfHasText() {
        // Given
        let textView = UITextView(frame: .zero)
        textView.text = ""
        
        // When
        viewController.textViewDidChange(textView)
        
        // Then
        XCTAssertFalse(viewController.submitCommentButton.isEnabled)
        
        // When
        textView.text = "a"
        viewController.textViewDidChange(textView)
        
        // Then
        XCTAssertTrue(viewController.submitCommentButton.isEnabled)
    }

}
