//
//  UserListCollectionViewCell.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import UIKit

class UserListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var incompleteTasksCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
