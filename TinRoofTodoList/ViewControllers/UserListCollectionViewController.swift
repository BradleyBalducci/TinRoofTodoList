//
//  UserListCollectionViewController.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import UIKit

class UserListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public weak var userSelectionDelegate: UserSelectionDelegate?
    private let reuseIdentifier = "UserListCell"
    private let cellHeight: CGFloat = 60.0
    private var users: [UserInfoModel] = []
    
    /// Wrapper for the ViewController's initializer
    ///
    /// - Parameter users: a list of user models whose info will be displayed by the collection view
    /// - Returns: a collection view controller responsible for displaying user info on our initial screen
    public static func getController(withUsers users: [UserInfoModel]) -> UserListCollectionViewController {
        let me = UserListCollectionViewController(nibName: "UserListCollectionViewController", bundle: nil)
        me.users = users
        return me
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func configureCollectionView() {
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.register(UINib(nibName: "UserListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserListCollectionViewCell
        let user = users[indexPath.row]
        cell.userIDLabel.text = "User: \(String(user.id))"
        let remainingTaskCount = user.remainingTasks.count
        cell.incompleteTasksCountLabel.text = remainingTaskCount > 99 ? "Tasks: 99+" : "Tasks: \(String(remainingTaskCount))"
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width, height: cellHeight)
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        userSelectionDelegate?.userWasSelected(user)
    }
}
