//
//  TaskCollectionViewController.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import UIKit


class TaskCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    private let reuseIdentifier = "TaskCell"
    private let cellHeight: CGFloat = 60.0
    private var tasks: [TaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "TaskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public static func getController() -> TaskCollectionViewController {
        let me = TaskCollectionViewController(nibName: "TaskCollectionViewController", bundle: nil)
        return me
    }
    
    public func loadData(forUser user: UserInfoModel, completion: @escaping () -> ()) {
        self.tasks = user.remainingTasks
        self.collectionView?.reloadData {
            completion()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaskCollectionViewCell
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task.title
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width, height: cellHeight)
        return size
    }
}
