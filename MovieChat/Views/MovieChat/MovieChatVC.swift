//
//  MovieChatVC.swift
//  MovieChat
//
//  Created by Felipe Leite on 10/11/19.
//  Copyright © 2019 FL. All rights reserved.
//

import UIKit

private let movieChatSegue = "MovieChatSegue"

class MovieChatVC : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitCommentButton: UIButton!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var commentTextViewContainerView: UIView!
    
    @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    var movie: Movie!
    lazy var presenter = MovieChatPresenter.defaultManager(movie: movie)
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObservers()
        applyVisuals()
        
        presenter.delegate = self
        presenter.delegateDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func submitButtonTapped() {
        let commentString = commentTextView.text ?? ""
        presenter.delegateWantsToSaveComment(commentString)
        
        commentTextView.text = ""
        submitCommentButton.isEnabled = false
    }
    
    // MARK: Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo,
            let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            let tableViewHeight = tableView.bounds.size.height
            let abc = tableView.contentSize.height - tableView.contentOffset.y
            let shouldScrollToBottom = abc <= tableViewHeight
            
            view.layoutIfNeeded()
            commentViewBottomConstraint.constant = kbFrame.height
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
            
            guard shouldScrollToBottom else { return }
            scrollToBottom()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let info = notification.userInfo,
            let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            view.layoutIfNeeded()
            commentViewBottomConstraint.constant = 0.0
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Helpers
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func applyVisuals() {
        title = movie.title
        
        tableView.separatorStyle = .none
        
        submitCommentButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        submitCommentButton.setTitle("+ Submit", for: .normal)
        submitCommentButton.setTitleColor(.white, for: .normal)
        submitCommentButton.setBackgroundImage(.from(.black), for: .normal)
        submitCommentButton.setBackgroundImage(.from(.gray), for: .disabled)
        submitCommentButton.layer.cornerRadius = 8.0
        submitCommentButton.layer.masksToBounds = true
        submitCommentButton.isEnabled = false
        
        commentTextViewContainerView.layer.masksToBounds = true
        commentTextViewContainerView.layer.cornerRadius = 8.0
        commentTextViewContainerView.layer.borderWidth = 1.5
        commentTextViewContainerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func scrollToBottom() {
        let numberOfRows = presenter.numberOfComments()
        guard numberOfRows > 0 else { return }
        
        let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension MovieChatVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfComments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = presenter.comment(atRow: indexPath.row)
        let isCurrentUser = presenter.isCommentFromCurrentUser(comment)
        let cell = CommentCell.dequeueReusableCell(from: tableView,
                                                   for: comment,
                                                   isCurrentUser: isCurrentUser)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

// MARK: - UITextViewDelegate

extension MovieChatVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        submitCommentButton.isEnabled = textView.text?.count ?? 0 > 0
    }
    
}

// MARK: - UITableViewDelegate

extension MovieChatVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

// MARK: - MovieChatPresenterDelegate

extension MovieChatVC : MovieChatPresenterDelegate {
    
    func showLoadError() {
        showAlert(title: "Could not load movie chat",
                  message: "Pleasy try again") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showCommentError() {
        showAlert(title: "Could not send comment",
                  message: "Pleasy try again")
    }
    
    func refreshComments() {
        tableView.reloadData()
        scrollToBottom()
    }
    
    // MARK: Helpers
    
    private func showAlert(title: String, message: String, action: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        }
        
        alertVC.addAction(dismissAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}
