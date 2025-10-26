//
//  ModelToDo.swift
//  ToDosTZ
//
//  Created by user on 8.10.25.
//

import Foundation

//struct ModelToDos: Codable {
//    let todos: [ModelToDo]
//    let total: Int
//    let skip: Int
//    let limit: Int
//}
//
//struct ModelToDo: Codable {
//    let id: Int
//    let todo: String
//    let completed: Bool
//    let userId: Int
//    
//    init(from: ToDos) {
//        self.id = Int(from.id)
//        self.todo = from.title ?? ""
//        self.completed = from.isCompleted
//        self.userId = Int(from.userId)
//    }
//}

struct ToDoModel: Codable {
    let id: String
    let title: String
    let text: String
    let isCompleted: Bool
    let date: String
    
    init(toDo: ToDos) {
        self.id = toDo.id ?? "0"
        self.title = toDo.title ?? ""
        self.text = toDo.text ?? ""
        self.isCompleted = toDo.isCompleted
        self.date = toDo.date ?? ""
    }
}

//struct ToDoModel2: Codable {
//    let id: String
//    let title: String
//    let text: String
//    let isCompleted: Bool
//    let date: String
//}
