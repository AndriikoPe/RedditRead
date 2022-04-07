//
//  PostViewController.swift
//  HT_2
//
//  Created by Пермяков Андрей on 12.02.2022.
//

import UIKit
import SDWebImage

class PostDetailsViewController: UIViewController {
    // MARK: - Data.
    var postsProvider = PostsProvider.shared
    var post: Post?
    
    // MARK: - Outlets.
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Actions.
    
    @IBAction private func shareTapped(_ sender: UIButton) {
        guard let url = post?.url else { return }
        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(avc, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let post = post { postsProvider.save(post) }
        self.post?.saved.toggle()
        display(post)
    }
    
    // MARK: - Lifecycle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display(post)
    }
    
    // MARK: - Displaying post.
    
    private func display(_ post: Post?) {
        guard let post = post else { return }
        DispatchQueue.main.async {
            self.setImage(using: post.imageUrl)
            
            self.detailsLabel.text = self
                .details(from: post.author, UtilityFuncs.convertToNice(post.time), post.domain)
            self.detailsLabel.sizeToFit()
            
            self.bookmarkButton.setImage(post.saved ? Constants.bookmarkFilledImage :
                                            Constants.bookmarkEmptyImage, for: .normal)
            
            self.descriptionLabel.text = post.title
            self.descriptionLabel.sizeToFit()
            
            self.ratingButton.setImage(post.isUpvoted ? Constants.ratingButtonPositive :
                                        Constants.ratingButtonNegative, for: .normal)
            self.ratingButton.setTitle(String(post.rating), for: .normal)
            self.ratingButton.setTitleColor(post.isUpvoted ? .systemGreen : .systemRed, for: .normal)
            self.ratingButton.tintColor = post.isUpvoted ? .systemGreen : .systemRed
            
            self.commentsButton.setTitle(String(post.comments), for: .normal)
        }
    }
    
    private func setImage(using url: URL?) {
        self.imageView.sd_setImage(with: url,
                                   placeholderImage: Constants.placeholderImage,
                                   options: SDWebImageOptions(rawValue: 0),
                                   completed: { (image, error, cache, urls) in
            if let image = image {
                self.imageView.image = image
            }
            self.layoutImage()
        })
    }
    
    private func layoutImage() {
        guard let image = imageView.image else { return }
        let ratio = image.size.width / image.size.height
        let newHeight = imageView.frame.width / ratio
        imageHeightConstraint.constant = newHeight
        view.layoutIfNeeded()
    }
    
    private func details(from name: String, _ time: String, _ domain: String) -> String {
        "u/\(name) • \(time) • \(domain)"
    }
}
