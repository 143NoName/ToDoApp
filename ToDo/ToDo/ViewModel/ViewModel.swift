//
//  ViewModel.swift
//  ToDosTZ
//
//  Created by user on 9.10.25.
//

import Foundation

class DateFormatterExtention {
    
    static let shared = DateFormatterExtention()
    
    func getFormattedDate(date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: Date())
    }
}

struct ViewModel {
    
    static let shared = ViewModel()
    
    let NS = NetworkService.shared              // для получения функций из сетевого менеджера
    let PC = PersistenceController.shared       // для получения функции добавления ToDo из контейнера
    
    func hasChanges(toDoModel: ToDoModel, toDoCoreData: ToDos) -> Bool {
        return toDoModel.title != toDoCoreData.title || toDoModel.text != toDoCoreData.text || toDoModel.isCompleted != toDoCoreData.isCompleted
    }
    
    func getToDos(toDos: [ToDos], limit: Int) {
        NS.getToDos(limit: limit) { result in
            switch result {
            case .success(let todos):
                for toDo in todos {
                    if toDos.contains(where: { $0.id == toDo.id }) {
                        return
                    } else {
                        PC.addToDos(id: toDo.id, title: toDo.title, text: toDo.text, isCompleted: toDo.isCompleted, date: toDo.date)
                    }
                }
            case .failure(let error):
                print("Ошибка при попытке получения: \(error.localizedDescription)")
            }
        }
    }
    
    func postNewToDo(newToDo: ToDos) {
        NS.postNewToDo(newToDo) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success:
                    print("Задача добавлена")
                case .failure(let error):
                    print("Ошибка при попытке добавления: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func putToDo(body: ToDos ,id: String) {
        NS.putToDo(body, id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Задача обновлена")
                case .failure(let error):
                    print("Ошибка обновления: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteToDo(id: String) {
        NS.deleteToDo(id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Задача удалена")
                case .failure(let error):
                    print("Ошибка при удалении: \(error.localizedDescription)")
                }
            }
        }
    }
}
