//
//  DatabaseManager.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    // MARK: Dependencies
    
    var firestore: Firestore!
    
    // MARK: Initializers
    
    class func defaultManager() -> DatabaseManager {
        
        return DatabaseManager(firestore: .firestore())
    }
    
    init(firestore: Firestore!) {
        self.firestore = firestore
    }
    
    // MARK: Public methods
    
    /// Adds a listener for updates on the given movie comments.
    ///
    /// Upon set up, the handler closure will be called with all
    /// comments from the given movie.
    ///
    /// - Parameters:
    ///   - movie: the movie to observer for comments updates.
    ///   - handler: a closure to be called when an update happens.
    func addListenerForComments(on movie: Movie,
                                handler: @escaping (Bool, [ Comment ]?) -> Void) {
        guard let movieTitle = movie.title else {
            handler(false, nil)
            return
        }
        
        firestore.collection("movies")
            .document(movieTitle)
            .collection("comments")
            .addSnapshotListener({ snapshot, error in
                guard error == nil, let documents = snapshot?.documentChanges else {
                    handler(false, nil)
                    return
                }
                
                let results = documents.filter { $0.type == .added }
                let comments = results.map { Comment(json: $0.document.data() )}
                handler(true, comments)
            })
    }
    
    /// Saves the given comment of the given movie.
    ///
    /// - Parameters:
    ///   - comment: a Comment instance.
    ///   - movie: a Movie instance.
    func saveComment(_ comment: Comment, on movie: Movie) {
        guard let movieTitle = movie.title else { return }
        let commentJSON = comment.toJSON()
        
        let moviesRef = firestore.collection("movies")
        
        moviesRef
            .document(movieTitle)
            .setData([:], merge: true) { error in
                guard error == nil else { return }
                moviesRef.document(movieTitle).collection("comments").addDocument(data: commentJSON)
        }
    }
    
}
