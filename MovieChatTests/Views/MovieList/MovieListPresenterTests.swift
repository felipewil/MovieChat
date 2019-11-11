//
//  MovieListPresenterTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class ServicesManagerMock : ServicesManager {
    
    var requestMoviesCalls = 0
    var requestMoviesHandler: ((Bool, [ Movie ]?) -> Void)!
    override func requestMovies(handler: @escaping (Bool, [Movie]?) -> Void) {
        requestMoviesCalls += 1
        requestMoviesHandler = handler
    }
    
}

private class MovieListPresenterDelegateMock : MovieListPresenterDelegate {
    
    var showErrorCalls = 0
    func showError() {
        showErrorCalls += 1
    }
    
    var refreshMoviesCalls = 0
    func refreshMovies() {
        refreshMoviesCalls += 1
    }
    
    var showChatCalls = 0
    func showChat(for movie: Movie) {
        showChatCalls += 1
    }
    
}

class MovieListPresenterTests: XCTestCase {

    var presenter: MovieListPresenter!
    private var delegateMock: MovieListPresenterDelegateMock!
    private var servicesManagerMock: ServicesManagerMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        servicesManagerMock = ServicesManagerMock(sessionManager: nil)
        delegateMock = MovieListPresenterDelegateMock()
        
        presenter = MovieListPresenter(servicesManager: servicesManagerMock)
        presenter.delegate = delegateMock
    }

    override func tearDown() {
        presenter = nil
        servicesManagerMock = nil
        delegateMock = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDelegateDidLoadShouldRequestMovies() {
        // Given
        // Initial state
        
        // When
        presenter.delegateDidLoad()
        
        // Then
        XCTAssertEqual(servicesManagerMock.requestMoviesCalls, 1)
    }
    
    func testDelegateWantsToReloadMoviesShouldRequestMovies() {
        // Given
        // Initial state
        
        // When
        presenter.delegateWantsToReloadMovies()
        
        // Then
        XCTAssertEqual(servicesManagerMock.requestMoviesCalls, 1)
    }
    
    func testUnsuccessfulRequestShouldShowError() {
        // Given
        presenter.delegateDidLoad()
        
        // When
        servicesManagerMock.requestMoviesHandler(false, nil)
        
        // Then
        XCTAssertEqual(delegateMock.showErrorCalls, 1)
        XCTAssertEqual(delegateMock.refreshMoviesCalls, 0)
    }
    
    func testSuccessfulRequestShouldRefreshMovies() {
        // Given
        presenter.delegateDidLoad()
        
        // When
        servicesManagerMock.requestMoviesHandler(true, nil)
        
        // Then
        XCTAssertEqual(delegateMock.showErrorCalls, 0)
        XCTAssertEqual(delegateMock.refreshMoviesCalls, 1)
    }
    
    func testDelegateDidSelectMovieShouldWarnDelegateToShowChat() {
        // Given
        let movie = Movie(json: [:])
        let result = [ movie ]
        
        presenter.delegateDidLoad()
        servicesManagerMock.requestMoviesHandler(true, result)
        
        // When
        presenter.delegateDidSelectMovie(atRow: 0)
        
        // Then
        XCTAssertEqual(delegateMock.showChatCalls, 1)
    }

    // MARK: DataSource
    
    func testNumbeOfMovies() {
        // Given
        let movie1 = Movie(json: [:])
        let movie2 = Movie(json: [:])
        let movie3 = Movie(json: [:])
        
        let result = [ movie1, movie2, movie3 ]
        
        presenter.delegateDidLoad()
        servicesManagerMock.requestMoviesHandler(true, result)
        
        // Then
        XCTAssertEqual(presenter.numberOfMovies(), 3)
    }
    
    func testMovieAtRow() {
        // Given
        let movie1 = Movie(json: [ "title": "movie1" ])
        let movie2 = Movie(json: [ "title": "movie2" ])
        let movie3 = Movie(json: [ "title": "movie3" ])
        
        let result = [ movie1, movie2, movie3 ]
        
        presenter.delegateDidLoad()
        servicesManagerMock.requestMoviesHandler(true, result)
        
        // Then
        XCTAssertEqual(presenter.movie(atRow: 1).title, "movie2")
    }

}
