//
//  Persistence.swift
//  ToDosTZ
//
//  Created by user on 4.10.25.
//

import CoreData
import SwiftUI

struct PersistenceController {
    
    static let shared = PersistenceController()

//    @MainActor
//    static let preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        
////        let toDosArray: [ToDos] = []
//        
////        for _ in 0..<1 {
//            let newItem = ToDos(context: viewContext)
//            newItem.id = 2
//            newItem.todo = "New ToDo"
//            newItem.isComplited = false
//            newItem.userId = 2
////        }
//        do {
//            try viewContext.save()
//        } catch {
//            print("Ошибка при попытке сохранения: \(error)")
//        }
//        return result
//    }()
//    Просто превью 
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoModel")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//          Для тестирования (true чтобы оставалось в ОЗУ, false для загрузки на диск)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                print("Ошибка при загрузке хранилища: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func creatToDo(id: String, title: String, text: String, isCompleted: Bool, date: String) -> ToDos {
        let toDo = ToDos(context: container.viewContext)
        toDo.id = id
        toDo.title = title
        toDo.text = text
        toDo.isCompleted = isCompleted
        toDo.date = date
        return toDo
    }
    
    func addToDos(id: String, title: String, text: String, isCompleted: Bool, date: String) {
        DispatchQueue.main.async {
            withAnimation {
                let newToDo = ToDos(context: container.viewContext)
                newToDo.id = id
                newToDo.title = title
                newToDo.text = text
                newToDo.isCompleted = isCompleted
                newToDo.date = date
                
                saveItems()
            }
        }
    }

//    func deleteItems(toDos: [ToDos], offsets: IndexSet) {
//        withAnimation {
//            offsets.map { toDos[$0] }.forEach(container.viewContext.delete)
//
//            do {
//                if container.viewContext.hasChanges {
//                    try container.viewContext.save()
//                }
//            } catch {
//                print("Ошибка при попытке удаления: \(error)")
//            }
//        }
//    }
    
    func deleteItem(toDo: ToDos) {
        withAnimation {
            container.viewContext.delete(toDo)
            
            saveItems()
        }
    }
    
    func editItem(item: ToDos, id: NSManagedObjectID) {
        DispatchQueue.main.async {
            withAnimation {
                do {
                    let newItem = try container.viewContext.existingObject(with: id)
                    
                    newItem.setValue(item.title, forKey: "title")
                    newItem.setValue(item.text, forKey: "text")
                } catch {
                    print("Ошибка при попытке изменить элемент: \(error)")
                }
                
                saveItems()
            }
        }
    }
    
    func saveItems() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        } catch {
            print("Ошибка при попытке сохранить: \(error)")
        }
    }
    
    
    func countOf() {
        // Получаем все сущности
        let entityNames = container.viewContext.persistentStoreCoordinator?.managedObjectModel.entities.compactMap { $0.name }
        
        for entityName in entityNames ?? [] {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            do {
                let results = try container.viewContext.fetch(fetchRequest)
                print("Сущность: \(entityName), количество: \(results.count)")
                
                // Выводим детали каждого объекта
                for object in results {
                    if let managedObject = object as? NSManagedObject {
                        print("  - \(managedObject)")
                    }
                }
            } catch {
                print("Ошибка при получении сущности \(entityName): \(error)")
            }
        }
    }
}

extension ToDos {
    func toCodableModel() -> ToDoModel {
        return ToDoModel(toDo: self)
    }
    func toData() throws -> Data {
        let data = self.toCodableModel()
        return try JSONEncoder().encode(data)
    }
}
