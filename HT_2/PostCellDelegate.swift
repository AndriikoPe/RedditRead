//
//  PostCellDelegate.swift
//  HT_2
//
//  Created by Пермяков Андрей on 10.03.2022.
//

import Foundation

protocol PostCellDelegate {
    func share(_ url: URL)
    func save(_ post: Post)
}
