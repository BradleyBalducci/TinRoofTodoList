//
//  ViewController.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UserSelectionDelegate {
    @IBOutlet weak var userListContainerView: UIView!
    
    private var transitioner: ViewTransitioner!
    private var userListVC: UserListCollectionViewController?
    private var userDetailVC: UserDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioner = ViewTransitioner(parent: self.view)
        fetchUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fetchUserData() {
        UserInfoFetcher.fetch { (success, users) in
            guard success else {
                // TODO: handle failure
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else {
                    return
                }
                self!.displayUserList(forUsers: users)
            }
        }
    }

    /// Creates our main UI classes and adds them to the transitioner. Note that only ViewController will facilitate communication between the
    /// child view controllers and our transitioner
    ///
    /// - Parameter users: list of unique users
    private func displayUserList(forUsers users: [UserInfoModel]) {
        userListVC = UserListCollectionViewController.getController(withUsers: users)
        userListVC!.userSelectionDelegate = self
        userDetailVC = UserDetailViewController.getController()
        userDetailVC!.userSelectionDelegate = self
        transitioner.addView(userListVC!.view)
        transitioner.addView(userDetailVC!.view)
    }
    
    // MARK: UserSelectionDelegate
    
    func userWasSelected(_ user: UserInfoModel) {
        // tell our detail vc (and therefore its child collection vc) to populate itself with the provided users data
        // once the data has been fully loaded the provided completion block will run, causing our transitioner to animate
        // appropriately
        userDetailVC!.loadData(forUser: user) { [weak self] in
            guard self != nil else {
                return
            }
            self!.transitioner.transition(inDirection: .left)
        }
    }
    
    func userWasDeselected() {
        transitioner.transition(inDirection: .right)
    }
}

