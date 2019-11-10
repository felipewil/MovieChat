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
    
    // MARK: Properties
    
    weak var delegate: WelcomePresenterDelegate?
    
    // MARK: Delegate methods
    
    func delegateDidUpdateName(_ name: String) {
        let isValid = name.count >= 3
        delegate?.enableEnter(isValid)
    }
    
}
