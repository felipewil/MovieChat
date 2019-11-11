//
//  MovieListPresenter.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

protocol MovieListPresenterDelegate : class {
    func showError()
    func refreshMovies()
    func showChat(for movie: Movie)
}

class MovieListPresenter {
    
    // MARK: Dependencies
    
    var servicesManager: ServicesManager!
    
    // MARK: Properties
    
    weak var delegate: MovieListPresenterDelegate?
    var movies: [ Movie ]
    
    // MARK: Initialization
    
    class func defaultPresenter() -> MovieListPresenter {
        return MovieListPresenter(servicesManager: .defaultManager())
    }
    
    init(servicesManager: ServicesManager!) {
        self.servicesManager = servicesManager
        self.movies = []
    }
    
    // MARK: Delegate methods
    
    func delegateDidLoad() {
        requestMovies()
    }
    
    func delegateWantsToReloadMovies() {
        requestMovies()
    }
    
    func delegateDidSelectMovie(atRow row: Int) {
        let movie = movies[row]
        delegate?.showChat(for: movie)
    }
    
    // MARK: DataSource
    
    /// The number of movies returned by the request.
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    /// Returns a movie at the given position.
    ///
    /// - Parameter row: the position to fetch the movie.
    /// - Returns: a Movie instance.
    func movie(atRow row: Int) -> Movie {
        return movies[row]
    }
    
    // MARK: Helpers
    
    private func requestMovies() {
        servicesManager.requestMovies { [ weak self ] success, movies in
            guard let self = self else { return }
            guard success else {
                self.delegate?.showError()
                return
            }
            
            self.movies = movies ?? []
            self.delegate?.refreshMovies()
        }
    }
    
}
