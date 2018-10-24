//
//  UserSelectionDelegate.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/24/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation

protocol UserSelectionDelegate: class {
    /// Communicates that a user cell was tapped, informing our detail vc of which user's data to display
    ///
    /// - Parameter user: the user whose info should appear on our detail page
    func userWasSelected(_ user: UserInfoModel)
    /// Communicates that user tapped the back button on the detail page
    func userWasDeselected()
}
