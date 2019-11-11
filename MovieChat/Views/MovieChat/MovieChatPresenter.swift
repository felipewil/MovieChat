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
    var userDefaults: UserDefaults!
    
    // MARK: Properties
    
    weak var delegate: MovieChatPresenterDelegate?
    var comments: [ Comment ]
    
    // MARK: Initializers
    
    class func defaultManager(movie: Movie) -> MovieChatPresenter {
        return MovieChatPresenter(movie: movie,
                                  databaseManager: .defaultManager(),
                                  userDefaults: .standard)
    }
    
    init(movie: Movie,
         databaseManager: DatabaseManager!,
         userDefaults: UserDefaults!) {
        self.movie = movie
        self.databaseManager = databaseManager
        self.userDefaults = userDefaults
        self.comments = []
    }
    
    // MARK: Delegate methods
    
    func delegateDidLoad() {
        databaseManager.addListenerForComments(on: movie) { [ weak self ] success, comments in
            guard let self = self else { return }

            self.comments.append(contentsOf: comments ?? [])
            self.delegate?.refreshComments()
        }
    }
    
    func delegateWantsToSaveComment(_ comment: String) {
        guard let userData = userDefaults.value(forKey: "currentUser") as? Data else {
            return
        }
        guard let user = try? PropertyListDecoder().decode(User.self, from: userData) else {
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
    
    func isCommentFromCurrentUser(_ comment: Comment) -> Bool {
        return comment.user?.name == currentUser()?.name
    }
    
    // MARK: Helpers
    
    private func currentUser() -> User? {
        guard let userData = userDefaults.value(forKey: "currentUser") as? Data else {
            return nil
        }
        return try? PropertyListDecoder().decode(User.self, from: userData)
    }
    
}
