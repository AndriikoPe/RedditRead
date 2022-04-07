//
//  Constants+Utilities.swift
//  HT_2
//
//  Created by Пермяков Андрей on 21.02.2022.
//

import UIKit

struct Constants {
    static let postCellID = "postCell"
    static let postSegueID = "postSegue"
    
    static let bookmarkEmptyImage = UIImage(systemName: "bookmark")
    static let bookmarkFilledImage = UIImage(systemName: "bookmark.fill")
    
    static let ratingButtonPositive = UIImage(systemName: "arrow.up")
    static let ratingButtonNegative = UIImage(systemName: "arrow.down")
    
    static let filterButtonInactive = UIImage(systemName: "bookmark.circle")
    static let filterButtonActive = UIImage(systemName: "bookmark.circle.fill")
    
    static let placeholderImage = UIImage(named: "PlaceholderImage")
}

struct UtilityFuncs {
    static func convertToNice(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            formatter.maximumUnitCount = 1

            return formatter.string(from: time) ?? String(time)
    }
}

extension IndexPath {
    init(index: Int) {
        self.init(item: index, section: 0)
    }
}
