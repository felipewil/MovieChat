//
//  Comment.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Comment {
    
    var content: String?
    var user: User?
    
    init(content: String) {
        self.content = content
    }
    
    init(json: [ String: Any ]) {
        self.content = json["content"] as? String
        
        guard let userJson = json["user"] as? [ String: Any ] else { return }
        self.user = User(json: userJson)
    }
    
    func toJSON() -> [ String: Any ] {
        return [
            "content": content ?? "",
            "insertTimestamp": FieldValue.serverTimestamp(),
            "user": user?.toJSON() ?? ""
        ]
    }
    
}
