//
//  PostView.swift
//  
//
//  Created by Пермяков Андрей on 05.05.2022.
//

import UIKit

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"
    
    // MARK: - Outlets.
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var postInfoView: UIView!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bookmarkButton: UIButton!
    @IBOutlet var ratingButton: UIButton!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    // MARK: - Actions.
    
    @IBAction private func bookmarkButtonTapped(_ sender: UIButton) {
        bookmarkButtonAction?(sender)
    }
    
    @IBAction private func shareButtonTapped(_ sender: UIButton) {
        shareButtonAction?(sender)
    }
    
    // MARK: - Inits.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    // MARK: - Intents.
    
    var bookmarkButtonAction: ((UIButton) -> Void)?
    var shareButtonAction: ((UIButton) -> Void)?
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
