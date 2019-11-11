//
//  MovieChatPresenter.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

protocol MovieChatPresenterDelegate : class {
    func showError()
    func refreshComments()
}

class MovieChatPresenter {
    
    // MARK: Dependencies
    
    var movie: Movie!
    var databaseManager: DatabaseManager!
    
    // MARK: Properties
    
    weak var delegate: MovieChatPresenterDelegate?
    var comments: [ Comment ]
    
    // MARK: Initializers
    
    class func defaultManager(movie: Movie) -> MovieChatPresenter {
        return MovieChatPresenter(movie: movie,
                                  databaseManager: .defaultManager())
    }
    
    init(movie: Movie,
         databaseManager: DatabaseManager!) {
        self.movie = movie
        self.databaseManager = databaseManager
        self.comments = []
    }
    
    // MARK: Delegate methods
    
    func delegateDidLoad() {
        #warning("TO DO")
    }
    
    func delegateWantsToSaveComment(_ comment: String) {
        #warning("TO DO")
    }
    
    // MARK: DataSource
    
    /// The number of comments for this movie chat.
    func numberOfComments() -> Int {
        return comments.count
    }
    
    /// Returns a comment at the given position.
    ///
    /// - Parameter row: the position to fetch the comment.
    /// - Returns: a Comment instance.
    func comment(atRow row: Int) -> Comment {
        return comments[row]
    }
    
}
