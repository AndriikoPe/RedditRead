//
//  PostTableViewCell.swift
//  HT_2
//
//  Created by Пермяков Андрей on 21.02.2022.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    weak var delegate: PostCellDelegate?
    
    private var post: Post?
    private var url: URL? { post?.url }
    
    private var supplementaryView: UIView?
    
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
            
            self.detailsLabel.text = UtilityFuncs
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
    
    // MARK: - Double tap save animation setup.
    
    private func layoutImage() {
        guard let image = postImageView.image else { return }
        let ratio = image.size.width / image.size.height
        let newHeight = postImageView.frame.width / ratio
        postImageView.isUserInteractionEnabled = true
        postImageHeightConstraint.constant = newHeight
        if supplementaryView == nil {
            supplementaryView = UtilityFuncs.setImageSupplementaryView(for: postImageView)
        }
        setImageSaveListener()
    }
    
    private func setImageSaveListener() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tryToSaveWithAnimation))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        postImageView.addGestureRecognizer(doubleTap)
    }
    // Only save (not delete) when double tapped.
    @objc private func tryToSaveWithAnimation() {
        guard let post = post else { return }
        if !post.saved { saveWithAnimation(post) }
    }
    
    private func saveWithAnimation(_ post: Post) {
        if supplementaryView == nil {
            supplementaryView = UtilityFuncs.setImageSupplementaryView(for: postImageView)
        }
        supplementaryView?.alpha = 1.0
        UIView.animate(withDuration: Constants.bigBookmarkAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: Constants.bigBookmarkSpringDamping,
                       initialSpringVelocity: Constants.initialSpringVelocity
        ) {
            self.supplementaryView?.transform = CGAffineTransform(
                scaleX: Constants.bigBookmarkScale,
                y: Constants.bigBookmarkScale
            )
        } completion: { _ in
            self.supplementaryView?.alpha = 0.0
            self.supplementaryView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.delegate?.save(post)
        }
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
