//
//  WelcomePresenter.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import Foundation

protocol WelcomePresenterDelegate : class {
    func enableEnter(_ enable: Bool)
}

class WelcomePresenter {
    
    private struct Consts {
        static let currentUserKey = "currentUser"
    }
    
    // MARK: Dependencies
    
    var userDefaults: UserDefaults!
    
    // MARK: Properties
    
    weak var delegate: WelcomePresenterDelegate?
    
    // MARK: Initializers
    
    class func defaultPresenter() -> WelcomePresenter {
        return WelcomePresenter(userDefaults: .standard)
    }
    
    init(userDefaults: UserDefaults!) {
        self.userDefaults = userDefaults
    }
    
    // MARK: Delegate methods
    
    func delegateDidUpdateName(_ name: String) {
        let isValid = name.count >= 3
        delegate?.enableEnter(isValid)
    }
    
    func delegateDidEnter(withName name: String) {
        let user = User(name: name)
        let encodedUser = try? PropertyListEncoder().encode(user)
        
        userDefaults.set(encodedUser, forKey: Consts.currentUserKey)
    }
    
}
