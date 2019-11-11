//
//  MovieChatPresenterTests.swift
//  MovieChatTests
//
//  Created by Guiche Virtual on 11/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class LoginManagerMock : LoginManager {
    
    var currentUserStub: User!
    override func currentUser() -> User? {
        return currentUserStub
    }
    
}

private class DatabaseManagerMock : DatabaseManager {
    
    var addListenerForCommentsCalls = 0
    var addListenerForCommentsHandler: ((Bool, [ Comment ]?) -> Void)!
    override func addListenerForComments(on movie: Movie, handler: @escaping (Bool, [Comment]?) -> Void) {
        addListenerForCommentsCalls += 1
        addListenerForCommentsHandler = handler
    }
    
    var saveCommentCalls = 0
    var saveCommentLastValue: Comment!
    override func saveComment(_ comment: Comment, on movie: Movie) {
        saveCommentCalls += 1
        saveCommentLastValue = comment
    }
    
}

private class MovieChatPresenterDelegateMock : MovieChatPresenterDelegate {
    
    var showLoadErrorCalls = 0
    func showLoadError() {
        showLoadErrorCalls += 1
    }
    
    var showCommentErrorCalls = 0
    func showCommentError() {
        showCommentErrorCalls += 1
    }
    
    var refreshCommentsCalls = 0
    func refreshComments() {
        refreshCommentsCalls += 1
    }
    
}

class MovieChatPresenterTests : XCTestCase {
    
    var presenter: MovieChatPresenter!
    private var delegateMock: MovieChatPresenterDelegateMock!
    private var loginManagerMock: LoginManagerMock!
    private var databaseManagerMock: DatabaseManagerMock!
    
    override func setUp() {
        super.setUp()
        
        delegateMock = MovieChatPresenterDelegateMock()
        loginManagerMock = LoginManagerMock(userDefaults: nil)
        databaseManagerMock = DatabaseManagerMock(firestore: nil)
        let movie = Movie(json: [:])
        
        presenter = MovieChatPresenter(movie: movie,
                                       databaseManager: databaseManagerMock,
                                       loginManager: loginManagerMock)
        presenter.delegate = delegateMock
    }
    
    override func tearDown() {
        presenter = nil
        delegateMock = nil
        loginManagerMock = nil
        databaseManagerMock = nil

        
        super.tearDown()
    }
    
    // MARK: - Delegate methods tests
    
    func testDelegateDidLoadShouldAddCommentsListener() {
        // Given
        // Initial state
        
        // When
        presenter.delegateDidLoad()
        
        // Then
        XCTAssertEqual(databaseManagerMock.addListenerForCommentsCalls, 1)
    }
    
    func testCommentsLoadUnsuccessShouldShowLoadError() {
        // Given
        presenter.delegateDidLoad()
        
        // When
        databaseManagerMock.addListenerForCommentsHandler(false, nil)
        
        // Then
        XCTAssertEqual(delegateMock.showLoadErrorCalls, 1)
    }
    
    func testCommentsLoadSuccessShouldRefreshComments() {
        // Given
        presenter.delegateDidLoad()
        
        // When
        databaseManagerMock.addListenerForCommentsHandler(true, [])
        
        // Then
        XCTAssertEqual(delegateMock.refreshCommentsCalls, 1)
    }
    
    func testDelegateWantsToSaveCommentWithoutCurrentUserShouldShowCommentError() {
        // Given
        loginManagerMock.currentUserStub = nil
        
        // When
        presenter.delegateWantsToSaveComment("some_comment")
        
        // Then
        XCTAssertEqual(delegateMock.showCommentErrorCalls, 1)
    }
    
    func testDelegateWantsToSaveCommentWithoutCurrentUserShouldShowCommentError2() {
        // Given
        loginManagerMock.currentUserStub = User(name: "some_name")
        
        // When
        presenter.delegateWantsToSaveComment("some_comment")
        
        // Then
        XCTAssertEqual(databaseManagerMock.saveCommentCalls, 1)
        XCTAssertEqual(databaseManagerMock.saveCommentLastValue.content, "some_comment")
        XCTAssertEqual(databaseManagerMock.saveCommentLastValue.user!.name, "some_name")
    }
    
    // MARK: - DataSource tests
    
    func testNumberOfComments() {
        // Given
        let comment1 = Comment(content: "")
        let comment2 = Comment(content: "")
        let comment3 = Comment(content: "")
        
        let comments = [ comment1, comment2, comment3 ]
        
        presenter.delegateDidLoad()
        databaseManagerMock.addListenerForCommentsHandler(true, comments)
        
        // Then
        XCTAssertEqual(presenter.numberOfComments(), 3)
    }
    
    func testCommentAtRow() {
        // Given
        let comment1 = Comment(content: "comment1")
        let comment2 = Comment(content: "comment2")
        let comment3 = Comment(content: "comment3")
        
        let comments = [ comment1, comment2, comment3 ]
        
        presenter.delegateDidLoad()
        databaseManagerMock.addListenerForCommentsHandler(true, comments)
        
        // Then
        XCTAssertEqual(presenter.comment(atRow: 1).content, "comment2")
    }
    
    func testIsCommentFromCurrentUser() {
        // Given
        loginManagerMock.currentUserStub = nil
        var comment = Comment(content: "")
        comment.user = User(name: "some_name")
        
        // Then
        XCTAssertFalse(presenter.isCommentFromCurrentUser(comment))
        
        // When
        loginManagerMock.currentUserStub = User(name: "some_name_2")
        
        // Then
        XCTAssertFalse(presenter.isCommentFromCurrentUser(comment))

        // When
        loginManagerMock.currentUserStub = User(name: "some_name")
        
        // Then
        XCTAssertTrue(presenter.isCommentFromCurrentUser(comment))
    }
    
}
