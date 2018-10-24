//
//  TaskModel.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation

public struct TaskModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
