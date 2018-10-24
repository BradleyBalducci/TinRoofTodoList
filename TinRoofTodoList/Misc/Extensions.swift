//
//  Extensions.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// Adds a completion block for the standard reloadData method. This will allow us to perform transitions only after the detail page's
    /// collection view has finished loading new user data, preventing any visual hiccups
    ///
    /// - Parameter completion: block of code to be run immediately after reloadData finishes
    public func reloadData(_ completion: @escaping () -> ()) {
        self.reloadData()
        self.performBatchUpdates(nil) { finished in
            guard finished else {
                return
            }
            completion()
        }
    }
}
