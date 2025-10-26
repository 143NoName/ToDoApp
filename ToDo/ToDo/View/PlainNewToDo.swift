//
//  PlainNewToDo.swift
//  ToDosTZ
//
//  Created by user on 9.10.25.
//


import SwiftUI
import CoreData

struct PlainNewToDo: View {
    
    let pc = PersistenceController.shared // временно, для проверки
    
    let vm = ViewModel.shared
    let df = DateFormatterExtention.shared
    
    @State var titleForField: String = ""
    @State var textForField: String = ""
        
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("Заголовок", text: $titleForField)
                    .font(.system(size: 24, weight: .bold))
                Text("\(df.getFormattedDate())")
                    .padding(.vertical, 6)
                    .foregroundStyle(.gray)
                TextEditor(text: $textForField)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Spacer()
                
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                        dismiss()

                        if titleForField.isEmpty && textForField.isEmpty {
                            return
                        } else {
                                                        
                            let newToDo = ToDos(context: viewContext)
                            newToDo.id = newToDo.hashValue.description
                            newToDo.title = titleForField
                            newToDo.text = textForField
                            newToDo.isCompleted = false
                            newToDo.date = df.getFormattedDate()
                            
                            vm.postNewToDo(newToDo: newToDo)
                            
                            do {
                                if viewContext.hasChanges {
                                    try viewContext.save()
                                } else {
                                    print("Контекст не изменился")
                                }
                            } catch {
                                print("Ошибка при сохранении: \(error)")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Назад")
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PlainNewToDo()
}

