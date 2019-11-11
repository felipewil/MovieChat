//
//  LoginManager.swift
//  MovieChat
//
//  Created by Guiche Virtual on 11/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

class LoginManager {
    
    private struct Consts {
        static let currentUserKey = "currentUser"
    }
    
    // MARK: Dependencies
    
    var userDefaults: UserDefaults!
    
    // MARK: Initializers
    
    class func defaultManager() -> LoginManager {
        return LoginManager(userDefaults: .standard)
    }
    
    init(userDefaults: UserDefaults!) {
        self.userDefaults = userDefaults
    }
    
    // MARK: Public methods
    
    /// Saves the current user to NSUserDefaults.
    /// - Parameter user: a User instance to be saved.
    func setCurrentUser(_ user: User) {
        let encodedUser = try? PropertyListEncoder().encode(user)
        
        userDefaults.set(encodedUser, forKey: Consts.currentUserKey)
    }
    
    /// Retrieves a user previously saved, or nil is it does not exist.
    func currentUser() -> User? {
        guard let userData = userDefaults.value(forKey: "currentUser") as? Data else {
            return nil
        }
        return try? PropertyListDecoder().decode(User.self, from: userData)
    }
    
}
