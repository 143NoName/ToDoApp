//
//  CheckButton.swift
//  ToDo
//
//  Created by user on 14.10.25.
//

import SwiftUI

struct CheckButton: View {
    
    @StateObject var toDo: ToDos
    
    let pc = PersistenceController.shared
    let vm = ViewModel.shared

    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            toDo.isCompleted ? Image(systemName: "checkmark")
                .resizable()
                .foregroundStyle(.yellow)
                .frame(width: 12, height: 12)
            : nil
            Circle()
                .fill(.clear)
                .stroke(toDo.isCompleted ? .yellow : .gray , lineWidth: 2)
                .animation(.linear(duration: 0.1), value: toDo.isCompleted)
                .frame(width: 24, height: 24)
        }
        .onTapGesture {
            toDo.isCompleted.toggle()  // изменяет значение в core data
            pc.saveItems()
            
            print(toDo)
            vm.putToDo(body: toDo, id: toDo.id ?? "0") // сохранение на сервер
        }
    }
}



/*
 
 
 curl -X PUT "http://localhost:3000/todos/2764407808" \
   -H "Content-Type: application/json" \
   -d '{
     "id": 2764407808,
     "title": "Обновленный заголовок",
     "text": "Обновленный текст",
     "isCompleted": true,
     "date": "25/10/25"
   }'
 
 
*/
