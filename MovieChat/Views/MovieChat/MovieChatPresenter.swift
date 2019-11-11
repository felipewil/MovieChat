//
//  MovieChatPresenter.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

protocol MovieChatPresenterDelegate : class {
    func showLoadError()
    func showCommentError()
    func refreshComments()
}

class MovieChatPresenter {
    
    // MARK: Dependencies
    
    var movie: Movie!
    var databaseManager: DatabaseManager!
    var loginManager: LoginManager!
    
    // MARK: Properties
    
    weak var delegate: MovieChatPresenterDelegate?
    var comments: [ Comment ]
    
    // MARK: Initializers
    
    class func defaultManager(movie: Movie) -> MovieChatPresenter {
        return MovieChatPresenter(movie: movie,
                                  databaseManager: .defaultManager(),
                                  loginManager: .defaultManager())
    }
    
    init(movie: Movie,
         databaseManager: DatabaseManager!,
         loginManager: LoginManager!) {
        self.movie = movie
        self.databaseManager = databaseManager
        self.loginManager = loginManager
        self.comments = []
    }
    
    // MARK: Delegate methods
    
    func delegateDidLoad() {
        databaseManager.addListenerForComments(on: movie) { [ weak self ] success, comments in
            guard let self = self else { return }
            guard success else {
                self.delegate?.showLoadError()
                return
            }

            self.comments.append(contentsOf: comments ?? [])
            self.delegate?.refreshComments()
        }
    }
    
    func delegateWantsToSaveComment(_ comment: String) {
        guard let user = loginManager.currentUser() else {
            delegate?.showCommentError()
            return
        }
        
        var comment = Comment(content: comment)
        comment.user = user

        databaseManager.saveComment(comment, on: movie)
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
    
    /// Checkes if the given comment belongs to the current user.
    /// - Parameter comment: a Comment instance to be checked.
    func isCommentFromCurrentUser(_ comment: Comment) -> Bool {
        return comment.user?.name == loginManager.currentUser()?.name
    }
    
}
