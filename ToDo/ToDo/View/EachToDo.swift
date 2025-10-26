//
//  EachToDo.swift
//  ToDoTZ
//
//  Created by user on 1.10.25.
//

import SwiftUI
import CoreData

struct EachToDo: View {
    
    @StateObject var toDo: ToDos
    let new: Bool
    
    let vm = ViewModel.shared
    let pc = PersistenceController.shared
    let df = DateFormatterExtention.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var titleForField: String = ""
    @State var textForField: String = ""
    
    @Environment(\.dismiss) private var dismiss
        
    func calcTitle() {
        guard let toDoTitle = toDo.title else { return }
        titleForField = toDoTitle
    }
    
    func calcText() {
        guard let toDoText = toDo.text else { return }
        textForField = toDoText
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                TextField("Заголовок", text: $titleForField)
                    .font(.system(size: 24, weight: .bold))
                    .onAppear {
                        calcTitle()
                    }
                
                Text(toDo.date ?? "Дата не найдена")
                    .foregroundStyle(.gray)
                
                TextEditor(text: $textForField)
                    .onAppear {
                        calcText()
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Spacer()
                
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        
                        if titleForField == toDo.title && textForField == toDo.text {
                            return // задача не изменилась
                        } else {
                            toDo.title = titleForField // изменение title в core data
                            toDo.text = textForField // изменение text в core data
                            pc.saveItems()
                            
                            vm.putToDo(body: toDo, id: toDo.id ?? "0")  // изменение на сервере

                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Назад")
                        }
                    }
                }
                
                ToolbarSpacer(placement: .topBarLeading)
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        toDo.isCompleted.toggle() // изменяет значение в core data
                        pc.saveItems()
                        
                        vm.putToDo(body: toDo, id: toDo.id ?? "0") // изменение на сервере
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .foregroundColor(toDo.isCompleted ? .green : .gray)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
