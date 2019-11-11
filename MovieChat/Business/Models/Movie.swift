//
//  Movie.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

struct Movie {
    
    var title: String?
    var director: String?
    var year: String?
    var runtime: String?
    
    init(json: [ String: Any ]) {
        self.title = json["title"] as? String
        self.director = json["director"] as? String
        self.year = json["year"] as? String
        self.runtime = json["runtime"] as? String
    }
    
}
