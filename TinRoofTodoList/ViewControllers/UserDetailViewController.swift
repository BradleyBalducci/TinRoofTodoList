//
//  UserDetailViewController.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var taskCollectionContainer: UIView!
    @IBOutlet weak var userLabel: UILabel!
    
    public weak var userSelectionDelegate: UserSelectionDelegate?
    private var user: UserInfoModel!
    private var taskCollection: TaskCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public static func getController() -> UserDetailViewController {
        let me = UserDetailViewController(nibName: "UserDetailViewController", bundle: nil)
        return me
    }
    
    private func addTaskCollection() {
        taskCollection = TaskCollectionViewController.getController()
        taskCollection.view.frame = taskCollectionContainer.bounds
        taskCollectionContainer.addSubview(taskCollection.view)
    }
    
    public func loadData(forUser user: UserInfoModel, completion: @escaping () -> ()) {
        self.user = user
        userLabel.text = "User: \(user.id)"
        taskCollection.loadData(forUser: user) {
            completion()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        userSelectionDelegate?.userWasDeselected()
    }
}
