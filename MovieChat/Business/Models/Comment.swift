//
//  Comment.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

struct Comment {
    
    var content: String?
    var user: User?
    
    init(content: String) {
        self.content = content
    }
    
    init(json: [ String: Any ]) {
        self.content = json["content"] as? String
    }
    
    func toJSON() -> [ String: Any ] {
        return [ "content": content ?? "" ]
    }
    
}
