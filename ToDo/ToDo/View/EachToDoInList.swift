//
//  EachToDoInList.swift
//  ToDo
//
//  Created by user on 14.10.25.
//

import SwiftUI

struct EachTodoInList: View {
    
    @StateObject var toDo: ToDos
    let date: Date
    
    let pc = PersistenceController.shared
    let df = DateFormatterExtention.shared
    let vm = ViewModel.shared
    
    var showTitle: String {
        guard let title = toDo.title, !title.isEmpty else { return "Задача №\(String(describing: toDo.id))" }
            return "\(title)"
    }
    
    var body: some View {
        HStack {
            VStack {
                CheckButton(toDo: toDo)
                Spacer()
            }
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 14))
        
            VStack(alignment: .leading) {
                Text("\(showTitle)")
                    .strikethrough(toDo.isCompleted ? true : false)
                    .animation(.linear(duration: 0.1), value: toDo.isCompleted)
                    .font(.system(size: 22))
                Text("\(toDo.text ?? "")")
                    .lineLimit(2)
                    .foregroundStyle(toDo.isCompleted ? .secondary : .primary)
                    .animation(.linear(duration: 0.1), value: toDo.isCompleted)
                    .padding(.vertical, 4)
                Text("\(df.getFormattedDate())")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contextMenu {
            NavigationLink {
                EachToDo(toDo: toDo, new: false)
            } label: {
                Text("Радактировать")
                Image(systemName: "square.and.pencil")
            }
            Button {
                print("Поделиться")
            } label: {
                HStack {
                    Text("Поделиться")
                    Image(systemName: "sharedwithyou")
                }
            }
            Button(role: .destructive) {
                pc.deleteItem(toDo: toDo)
                let id = toDo.id ?? "0"
                vm.deleteToDo(id: id)
            } label: {
                HStack {
                    Text("Удалить")
                    Image(systemName: "trash")
                }
            }
        }
    }
}


//#Preview {
//    EachTodoInList(toDo: <#T##ToDos#>, date: <#T##Date#>)
//}
