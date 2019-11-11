//
//  MovieListVCTests.swift
//  MovieChatTests
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import XCTest
@testable import MovieChat

private class MovieListPresenterMock : MovieListPresenter {
    
    var delegateDidLoadCalls = 0
    override func delegateDidLoad() {
        delegateDidLoadCalls += 1
    }
    
    var delegateWantsToReloadMoviesCalls = 0
    override func delegateWantsToReloadMovies() {
        delegateWantsToReloadMoviesCalls += 1
    }
    
    var delegateDidSelectMovieCalls = 0
    override func delegateDidSelectMovie(atRow row: Int) {
        delegateDidSelectMovieCalls += 1
    }
    
    var numberOfMoviesCalls = 0
    override func numberOfMovies() -> Int {
        numberOfMoviesCalls += 1
        return 0
    }
    
    var movieAtRowCalls = 0
    override func movie(atRow row: Int) -> Movie {
        movieAtRowCalls += 1
        return Movie(json: [:])
    }
    
}

private class UINavigationControllerMock : UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers.append(viewController)
    }
    
}

class MovieListVCTests: XCTestCase {

    var viewController: MovieListVC!
    private var presenterMock: MovieListPresenterMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenterMock = MovieListPresenterMock(servicesManager: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "MovieListVC") as? MovieListVC
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

    // MARK: - Life cycle tests
    
    func testViewDidLoadShouldWarnPresenter() {
        // Given
        presenterMock.delegateDidLoadCalls = 0
        
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertEqual(presenterMock.delegateDidLoadCalls, 1)
    }
    
    // MARK: - Actions tests
    
    func testRequestMoviesButtonTappedShouldWarnPresenter() {
        // Given
        // Initial state
        
        // When
        viewController.requestMoviesButtonTapped()
        
        // Then
        XCTAssertEqual(presenterMock.delegateWantsToReloadMoviesCalls, 1)
    }
    
    // MARK: - UITableViewDataSource tests

    func testNumberOfRowsShouldAskPresenter() {
        // Given
        // Initial state
        
        // When
        _ = viewController.tableView(viewController.tableView,
                                     numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(presenterMock.numberOfMoviesCalls, 1)
    }
    
    func testCellForRowShouldReturnMovieCell() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cell = viewController.tableView(viewController.tableView,
                                            cellForRowAt: indexPath)
        
        // Then
        XCTAssertTrue(cell is MovieCell)
        XCTAssertEqual(presenterMock.movieAtRowCalls, 1)
    }
    
    // MARK: - UITableViewDelegate tests
    
    func testRowSelectedShouldWarnPresenter() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertEqual(presenterMock.delegateDidSelectMovieCalls, 1)
    }
    
    // MARK: - MovieListPresenterDelegate tests
    
    func testShowChatShouldSegueToMovieChat() {
        // Given
        let navVC = UINavigationControllerMock(rootViewController: viewController)
        
        XCTAssertEqual(navVC.viewControllers.count, 1)
        
        // When
        viewController.showChat(for: Movie(json: [:]))
        
        // Then
        XCTAssertEqual(navVC.viewControllers.count, 2)
        XCTAssertTrue(navVC.viewControllers.last! is MovieChatVC)
        
        navVC.viewControllers = []
    }
    
}
