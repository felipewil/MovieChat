//
//  WelcomeVC.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

private let movieListSegue = "MovieListSegue"

class WelcomeVC : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    // MARK: Properties
    
    lazy var presenter = WelcomePresenter.defaultPresenter()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        applyVisuals()
    }
    
    // MARK: Actions
    
    @IBAction func editingChanged(_ sender: UITextField) {
        presenter.delegateDidUpdateName(sender.text ?? "")
    }
    
    @IBAction func enterButtonTapped() {
        let name = nameTextField.text ?? ""
        presenter.delegateDidEnter(withName: name)
        performSegue(withIdentifier: movieListSegue, sender: nil)
    }
    // MARK: Helpers
    
    private func applyVisuals() {
        messageLabel.text = "Welcome to MovieChat"
        nameTitleLabel.text = "Enter your name to begin"
        enterButton.setTitle("Enter", for: .normal)
        
        messageLabel.font = .systemFont(ofSize: 24.0)
        nameTitleLabel.font = .systemFont(ofSize: 17.0)
        nameTextField.font = .systemFont(ofSize: 17.0)
        enterButton.titleLabel?.font = .systemFont(ofSize: 17.0)
        
        nameTextField.autocapitalizationType = .words
        nameTextField.keyboardType = .asciiCapable
        nameTextField.returnKeyType = .done
        
        enterButton.isEnabled = false
    }
    
}

// MARK: - WelcomePresenterDelegate

extension WelcomeVC : WelcomePresenterDelegate {
    
    func enableEnter(_ enable: Bool) {
        enterButton.isEnabled = enable
    }
    
}

// MARK: - UITextFieldDelegate

extension WelcomeVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterButton.isEnabled {
            enterButtonTapped()
        }
        
        return true
    }
    
}
