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
                if !ongoingTodos.isEmpty {
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
                        .presentationDetents([.medium])
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
                            .presentationDetents([.medium])
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
                        } label : {
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
        .modelContainer(for: TodoItem.self)
}
