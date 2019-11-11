//
//  ServicesManager.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation
import Alamofire

class ServicesManager {
    
    private let moviesURL = "https://tender-mclean-00a2bd.netlify.com/mobile/movies.json"
    
    // MARK: Dependencies
    
    var sessionManager: SessionManager!
    
    // MARK: Initialization
    
    /// Default initializer with dependency injection.
    ///
    /// - Returns: A ServicesManager instance.
    class func defaultManager() -> ServicesManager {
        return ServicesManager(sessionManager: SessionManager(configuration: .default))
    }
    
    /// Initializer with given dependencies.
    ///
    /// - Parameter sessionManager: A SessionManager instance.
    init(sessionManager: SessionManager!) {
        self.sessionManager = sessionManager
    }
    
    // MARK: Public methods
    
    
    /// Requests movies and call handler upon completion.
    ///
    ///
    /// - Parameter handler: closure called upon request completion.
    /// - Parameter success: wheter the request was successful and returned correct data.
    /// - Parameter movies: array of Movie instances mapped from request response; nil if the
    /// request was not successful.
    func requestMovies(handler: @escaping (_ success: Bool, _ movies: [ Movie ]?) -> Void) {
        sessionManager.request(moviesURL).responseJSON { response in
            guard response.error == nil,
                let result = response.result.value as? [[ String: Any ]] else {
                handler(false, nil)
                return
            }
            
            let movies = result.map { Movie(json: $0) }
            handler(true, movies)
        }
    }
    
}
