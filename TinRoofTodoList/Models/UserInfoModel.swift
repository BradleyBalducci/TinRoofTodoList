//
//  UserInfoModel.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation

public struct UserInfoModel {
    public var id: Int
    public var remainingTasks: [TaskModel]
    init(id: Int) {
        self.id = id
        self.remainingTasks = []
    }
    
    public mutating func addTask(_ task: TaskModel) {
        remainingTasks.append(task)
    }
}
