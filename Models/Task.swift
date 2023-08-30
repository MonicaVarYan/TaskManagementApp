//
//  Task.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-02.
//

import Foundation

class Task {
    var taskId: Int = 0
    var listId: Int = 0
    var name: String = ""
    var isCompleted:Bool = false
    
    
    init(taskId:Int, listId: Int, name:String, isCompleted: Bool)
    {
        self.taskId = taskId
        self.listId = listId
        self.name = name
        self.isCompleted = isCompleted
    }
}

