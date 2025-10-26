//
//  ToDosTZApp.swift
//  ToDosTZ
//
//  Created by user on 4.10.25.
//

import SwiftUI
import CoreData



@main
struct ToDosTZApp: App {
    let persistenceController = PersistenceController.shared
//    let vm = ViewModel.shared

    var body: some Scene {
        WindowGroup {
            ViewToDo()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environment(\.PC, persistenceController)
            
        }
    }
}
