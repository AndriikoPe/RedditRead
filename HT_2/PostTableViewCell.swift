//
//  PostTableViewCell.swift
//  HT_2
//
//  Created by Пермяков Андрей on 21.02.2022.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    var delegate: PostCellDelegate?
    
    private var post: Post?
    private var url: URL? { post?.url }
    
    // MARK: - Outlets.
    
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    // MARK: - Actions.
    
    @IBAction private func share(_ sender: UIButton) {
        guard let url = url else { return }
        delegate?.share(url)
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        guard let post = post else { return }
        delegate?.save(post)
    }
    
    // MARK: - Configurations.
    
    func configure(with post: Post) {
        self.post = post
        DispatchQueue.main.async {
            self.setImage(using: post.imageUrl)
            
            self.detailsLabel.text = self
                .details(from: post.author, UtilityFuncs.convertToNice(post.time), post.domain)
            self.detailsLabel.sizeToFit()
            
            self.bookmarkButton.setImage(post.saved ? Constants.bookmarkFilledImage
                                         : Constants.bookmarkEmptyImage, for: .normal)
            
            self.titleLabel.text = post.title
            self.titleLabel.sizeToFit()
            
            self.ratingButton.setImage(post.isUpvoted ? Constants.ratingButtonPositive :
                                        Constants.ratingButtonNegative, for: .normal)
            self.ratingButton.setTitle(String(post.rating), for: .normal)
            self.ratingButton.setTitleColor(post.isUpvoted ? .systemGreen : .systemRed, for: .normal)
            self.ratingButton.tintColor = post.isUpvoted ? .systemGreen : .systemRed
            
            self.commentsButton.setTitle(String(post.comments), for: .normal)
            
            self.contentView.layoutIfNeeded()
        }
    }
    
    private func layoutImage() {
        guard let image = postImageView.image else { return }
        let ratio = image.size.width / image.size.height
        let newHeight = postImageView.frame.width / ratio
        postImageHeightConstraint.constant = newHeight
    }
    
    
    private func details(from name: String, _ time: String, _ domain: String) -> String {
        "u/\(name) • \(time) • \(domain)"
    }
    
    private func setImage(using url: URL?) {
        self.postImageView.sd_setImage(with: url,
                                   placeholderImage: Constants.placeholderImage,
                                   options: SDWebImageOptions(rawValue: 0),
                                   completed: { (image, error, cache, urls) in
            if let image = image {
                self.postImageView.image = image
            }
            self.layoutImage()
        })
    }
}
