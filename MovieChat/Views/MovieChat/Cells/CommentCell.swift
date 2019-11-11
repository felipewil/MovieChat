//
//  CommentCell.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

class CommentCell : UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var pictureBackgroundView: UIView!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
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
    
    static let reuseIdentifier = "CommentCell"
    
    // MARK: Public methods
    
    class func dequeueReusableCell(from tableView: UITableView,
                                   for comment: Comment) -> CommentCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! CommentCell
        
        cell.commentLabel.text = comment.content
        cell.authorLabel.text = comment.user?.name
        
        return cell
    }
    
    // MARK: Helpers
    
    private func applyVisuals() {
        pictureImageView.image = UIImage(named: "IconPerson")?.withRenderingMode(.alwaysTemplate)
        pictureImageView.tintColor = .white
        
        pictureBackgroundView.backgroundColor = .gray
        
        pictureImageView.layer.masksToBounds = true
        pictureImageView.layer.cornerRadius = pictureImageView.bounds.width * 0.5
        
        commentLabel.font = .systemFont(ofSize: 17.0)
        authorLabel.font = .systemFont(ofSize: 13.0)
    }
    
}
