//
//  ContentView.swift
//  ToDoList
//
//  Created by Gdwn16 on 02/12/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) var context
    @State private var showCreateSheet: Bool = false
    @State private var showCompletedTask: Bool = false
    @State private var selectedTodo: TodoItem?  // to hold the todoItem (optional as it could be nil)
    @Query private var todoQuery: [TodoItem]  // query fetches the content of model. in this case i specified that it's an array of TodoItem objects.
    // whenever the content of the model changes, this is auto re-rendered
    // this is interesting because you can have multiple queries that do different things as below

    // add a filter based on which one has isCompleted set to false
    // i.e the undone tasks
    // i can also specify the order to sort
    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \TodoItem.timeStamp,
        order: .forward
    ) private var ongoingTodos: [TodoItem]

    // the opposite of above
    @Query(
        filter: #Predicate { $0.isCompleted == true },
        sort: \TodoItem.timeStamp
    ) private var completedTodos: [TodoItem]

    var body: some View {
        NavigationStack {
            List {
                // ongoing tasks list
                if ongoingTodos.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray.full.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(BrandColors.Gray400)
                        Text("You have no ongoing tasks")
                            .font(.system(size: 17))
                            .foregroundStyle(BrandColors.Gray400)
                        MainButton(label: "Add a task", height: 32) {
                            showCreateSheet.toggle()
                        }
                        .padding(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))
                    .frame(minHeight: 256)
                }
                ForEach(ongoingTodos) { item in
                    Button {
                        selectedTodo = item
                    } label: {
                        ToDoCard(todoObj: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                                try? context.save()  // add this to persistent storage immediately
                            }
                        } label: {
                            Image(systemName: "trash")
                        }

                        Button {
                            selectedTodo = item
                        } label: {
                            Image(systemName: "pencil")
                                .tint(.blue)
                        }
                    }
                }

                // Show and hide completed tasks button
                Button {
                    withAnimation(.smooth(duration: 0.5)) {
                        showCompletedTask.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "eye.fill")
                            .foregroundStyle(
                                showCompletedTask ? .black : .gray
                            )
                            .rotation3DEffect(
                                .degrees(showCompletedTask ? 180 : 0),
                                axis: (x: 1, y: 0, z: 0)
                            )
                        Text("Completed tasks")
                            .font(.system(size: 20))
                        Spacer()
                        Image(
                            systemName: "chevron.down"
                        )
                        .rotation3DEffect(
                            .degrees(showCompletedTask ? 180 : 0),
                            axis: (x: 1, y: 0, z: 0)
                        )
                    }
                    .foregroundStyle(.black)
                }

                // completed tasks list
                if showCompletedTask {
                    if completedTodos.isEmpty {
                        Text("No completed tasks here")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(completedTodos) { item in
                            ToDoCard(todoObj: item)
                                .buttonStyle(PlainButtonStyle())
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(item)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                        }

                    }
                }

            }
            .listStyle(.grouped)
            .navigationTitle("Your tasks")
            .sheet(isPresented: $showCreateSheet) {
                NavigationStack {
                    CreateToDo()
                        .interactiveDismissDisabled()
//                        .presentationDetents([.medium])
                }
            }
            .sheet(
                // when selectedTodo changes, open this sheet
                item: $selectedTodo,
                onDismiss: {
                    // when you close the sheet (you don't have to do this)
                    selectedTodo = nil
                },
                content: { todo in
                    // what should be in the sheet
                    NavigationStack {
                        ToDoDetail(todoObj: todo)
                            .interactiveDismissDisabled()
//                            .presentationDetents([.medium])
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        NavigationLink(destination: AllCategories()) {
                            HStack {
                                Image(systemName: "rectangle.stack")
                                Text("Categories")
                            }
                        }

                        Button {
                            // for filters
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "line.3.horizontal.decrease")
                                Text("Filters")
                            }
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TodoItem.self, Categories.self])
}
