//
//  User.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

struct User : Codable {
    
    var name: String?
    
    init(name: String) {
        self.name = name
    }
    
    init(json: [ String: Any ]) {
        self.name = json["name"] as? String
    }
    
    func toJSON() -> [ String: Any ]{
        return [ "name": name ?? "" ]
    }
    
}
