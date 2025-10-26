///
//  ContentView.swift
//  ToDosTZ
//
//  Created by user on 4.10.25.
//

import SwiftUI
import CoreData

//enum ResultFromSearch {
//    case array([ToDos])
//    case text(String)
//}

struct FilterManager {
    
    static let shared = FilterManager()
    
//    func searchFunc(toDos: [ToDos], search: String) -> ResultFromSearch {
//        guard !search.isEmpty else { return .array(toDos) }
//        let searchArray = toDos.filter { each in
//            each.text!.lowercased().contains(search.lowercased())
//        }
//        if searchArray.isEmpty {
//            return .text("Ничего не найдено")
//        } else {
//            return .array(searchArray)
//        }
//    }
    
    func searchFunc(toDos: [ToDos], search: String) -> [ToDos] {
        guard !search.isEmpty else { return toDos }
        return toDos.filter { each in
            each.text!.lowercased().contains(search.lowercased()) || each.title!.lowercased().contains(search.lowercased())
        }
    }
}

struct ViewToDo: View {
    
    let fm = FilterManager.shared
    let pc = PersistenceController.shared
    let vm = ViewModel.shared
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ToDos.id, ascending: true)],
        animation: .default)
    private var toDos: FetchedResults<ToDos>
    
    @State var cearchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                if toDos.isEmpty {
                    ScrollView {
                        VStack(alignment: .center) {
                            Text("У вас пока что нет заметок")
                        }
                        .frame(height: 600, alignment: .center)
                    }
                } else {

                    List {
                        ForEach(fm.searchFunc(toDos: Array(toDos), search: cearchText)) { each in
                            NavigationLink {
                                EachToDo(toDo: each, new: false)
                            } label: {
                                EachTodoInList(toDo: each, date: Date())
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    
                                } label: {
                                    Text("Поделиться")
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .tint(.blue)
                                
                                NavigationLink {
                                    EachToDo(toDo: each, new: false)
                                } label: {
                                    Text("Радактировать")
                                    Image(systemName: "square.and.pencil")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    
                                    let id = each.id ?? "0"
                                    
                                    pc.deleteItem(toDo: each)
                                    vm.deleteToDo(id: id)

                                } label: {
                                    Text("Удалить")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $cearchText, prompt: Text("Поиск по содержимому"))
                }
            }
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem {
                    Text("Задач: \(toDos.count)")
                        .padding(.horizontal)
                }
                ToolbarSpacer()
                ToolbarItem {
                    NavigationLink {
//                        EachToDo(toDo: ToDos(context: viewContext), new: false)
                        PlainNewToDo()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 15))
                            .padding(.bottom, 4)
                    }
                }
            }
            
            .onAppear {
//                vm.getToDos(toDos: Array(toDos), limit: 100)

            }
            .refreshable {
//                vm.getToDos(toDos: Array(toDos), limit: 15)
                do {
                    let request: NSFetchRequest<ToDos> = ToDos.fetchRequest()
                    print(try pc.container.viewContext.fetch(request))
                } catch {
                    print("")
                }
            }
        }
    }
}


#Preview {
    ViewToDo()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
