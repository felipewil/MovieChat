//
//  MovieListVC.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

class MovieListVC : UIViewController {
    
    private struct Consts {
        static let animationDuration: TimeInterval = 0.3
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var requestMoviesButton: UIButton!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    // MARK: Properties
    
    lazy var presenter = MovieListPresenter.defaultPresenter()
    
    // MARK: Actions
    
    @IBAction func requestMoviesButtonTapped() {
        presenter.delegateWantsToReloadMovies()
        
        UIView.animate(withDuration: Consts.animationDuration) {
            self.loadingView.alpha = 1.0
            self.tableView.alpha = 0.0
            self.errorView.alpha = 0.0
        }
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        presenter.delegateDidLoad()
        
        applyVisuals()
    }
    
    // MARK: Apply visuals
    
    private func applyVisuals() {
        tableView.alpha = 0.0
        errorView.alpha = 0.0
        loadingView.alpha = 1.0
        
        loadingLabel.text = "Fetching movies!"
        
        requestMoviesButton.setTitle("Reload movies", for: .normal)
    }
    
}

// MARK: - UITableViewDataSource

extension MovieListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = presenter.movie(atRow: indexPath.row)
        return MovieCell.dequeueReusableCell(from: tableView,
                                             for: movie)
    }
    
}

// MARK: - MovieListPresenterDelegate

extension MovieListVC : MovieListPresenterDelegate {
    
    func refreshMovies() {
        tableView.reloadData()
        
        UIView.animate(withDuration: Consts.animationDuration) {
            self.loadingView.alpha = 0.0
            self.tableView.alpha = 1.0
        }
    }
    
    func showError() {
        let alertVC = UIAlertController(title: "Could not load movies", message: "Pleasy try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        
        alertVC.addAction(dismissAction)
        present(alertVC, animated: true, completion: nil)
        
        UIView.animate(withDuration: Consts.animationDuration) {
            self.loadingView.alpha = 0.0
            self.errorView.alpha = 1.0
        }
    }
    
}
