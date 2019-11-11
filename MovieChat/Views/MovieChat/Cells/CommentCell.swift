//
//  CommentCell.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

class CommentCell : UITableViewCell {
    
    private struct Consts {
        static let defaultMargin: CGFloat = 64.0
        static let closerMargin: CGFloat = 16.0
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var pictureBackgroundView: UIView!
    @IBOutlet weak var myPictureBackgroundView: UIView!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var myPictureImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var commentLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabelTrailingConstraint: NSLayoutConstraint!
    
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
                                   for comment: Comment,
                                   isCurrentUser: Bool) -> CommentCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! CommentCell
        
        cell.commentLabel.text = comment.content
        cell.authorLabel.text = comment.user?.name
        
        if isCurrentUser {
            cell.pictureBackgroundView.alpha = 0.0
            cell.myPictureBackgroundView.alpha = 1.0
            cell.commentLabelLeadingConstraint.constant = Consts.closerMargin
            cell.commentLabelTrailingConstraint.constant = Consts.defaultMargin
            
            cell.commentLabel.textAlignment = .right
            cell.authorLabel.textAlignment = .right
        }
        else {
            cell.pictureBackgroundView.alpha = 1.0
            cell.myPictureBackgroundView.alpha = 0.0
            cell.commentLabelLeadingConstraint.constant = Consts.defaultMargin
            cell.commentLabelTrailingConstraint.constant = Consts.closerMargin
            
            cell.commentLabel.textAlignment = .left
            cell.authorLabel.textAlignment = .left
        }
        
        return cell
    }
    
    // MARK: Helpers
    
    private func applyVisuals() {
        setUpPictureImageView(pictureImageView, backgroundView: pictureBackgroundView, backgroundColor: .lightGray)
        setUpPictureImageView(myPictureImageView, backgroundView: myPictureBackgroundView, backgroundColor: .darkGray)
        
        commentLabel.font = .systemFont(ofSize: 17.0)
        authorLabel.font = .systemFont(ofSize: 13.0, weight: .semibold)
    }
    
    private func setUpPictureImageView(_ pictureImageView: UIImageView, backgroundView: UIView, backgroundColor: UIColor) {
        pictureImageView.image = UIImage(named: "IconPerson")?.withRenderingMode(.alwaysTemplate)
        pictureImageView.tintColor = .white
        
        backgroundView.backgroundColor = backgroundColor
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = pictureBackgroundView.bounds.width * 0.5
    }
    
}
