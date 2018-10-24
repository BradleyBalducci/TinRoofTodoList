//
//  UserInfoFetcher.swift
//  TinRoofTodoList
//
//  Created by Paul Balducci on 10/23/18.
//  Copyright © 2018 Bradley Balducci. All rights reserved.
//

import Foundation

public class UserInfoFetcher {
    private static var currentDataTask: URLSessionTask?
    
    /// Performs request for our task json data, converts the data into unique user models, and provides access to those models
    /// via a completion block
    ///
    /// - Parameter completion: block that dictates how to handle both successful and unsuccessful data requests
    public static func fetch(completion: @escaping (Bool, [UserInfoModel]) -> ()) {
        guard let url = URL(string: "http://jsonplaceholder.typicode.com/todos") else {
            completion(false, [])
            return
        }
        
        // we don't want multiple tasks firing simultaneously in the event that this method is accidentally called repeatedly
        if let task = currentDataTask {
            task.cancel()
        }
        
        currentDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, response != nil, let data = data else {
                self.currentDataTask = nil
                completion(false, [])
                return
            }
            
            do {
                // decode our json in TaskModels
                let jsonDecoder = JSONDecoder()
                let tasks = try jsonDecoder.decode([TaskModel].self, from: data)
                // convert the task data into user data
                let userInfoList = self.convertTasksToUserList(tasks)
                self.currentDataTask = nil
                completion(true, userInfoList)
            } catch {
                self.currentDataTask = nil
                completion(false, [])
            }
        }
        currentDataTask!.resume()
    }
    
    /// Creates a set of unique user models from a list of task models. The user models will only contain info about uncompleted tasks and
    /// will be ordered by the number of incomplete tasks
    ///
    /// - Parameter tasks: The tasks recieved from our json fetch call
    /// - Returns: a list of unique, sorted user models
    private static func convertTasksToUserList(_ tasks: [TaskModel]) -> [UserInfoModel] {
        // group incomplete tasks into users
        var userIDDict = Dictionary<Int, UserInfoModel>()
        _ = tasks.filter { !$0.completed }.map { task in
            let userId = task.userId
            var newUserInfo = userIDDict[userId] ?? UserInfoModel(id: userId)
            newUserInfo.addTask(task)
            userIDDict[userId] = newUserInfo
        }
        // sort tasks by the number of remaining tasks each user has so that our collection will display them in descending order
        let orderedUsers = userIDDict.values.sorted { $0.remainingTasks.count > $1.remainingTasks.count }
        return orderedUsers
    }
}
