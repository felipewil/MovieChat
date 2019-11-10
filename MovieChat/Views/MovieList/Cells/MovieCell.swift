//
//  MovieCell.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

class MovieCell : UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyVisuals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyVisuals()
    }
    
    // MARK: Properties
    
    static let reuseIdentifier = "MovieCell"
    
    // MARK: Public methods
    
    class func dequeueReusableCell(from tableView: UITableView, for movie: Movie) -> MovieCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MovieCell
        
        cell.nameLabel.text = movie.title
        cell.directorLabel.text = "Directed by: \(movie.director ?? "")"
        cell.yearLabel.text = movie.year
        
        return cell
    }
    
    // MARK: - Helpers
    
    private func applyVisuals() {
        nameLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        directorLabel.font = .systemFont(ofSize: 15.0)
        yearLabel.font = .systemFont(ofSize: 15.0)
    }
    
}
