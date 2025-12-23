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
    @State private var searchQuery: String = ""
    @State private var navigationTitle: String = ""
    @State private var showSearchBar : Bool = false
    @State private var selectedTodo: TodoItem?
    @Query private var todoQuery: [TodoItem]
    // query fetches the content of model. in this case i specified that it's an array of TodoItem objects.
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

    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]

    var body: some View {
        NavigationStack {
            List {
                if showCompletedTask {
                    completedTaskList()
                } else {
                    ongoingTaskList()
                }
            }
            .listStyle(.grouped)
            .padding(.bottom, 48)
            .navigationTitle(
                navigationTitleName(
                    todo: showCompletedTask ? searchCompletedTodos : searchOngoingTodos,
                    taskName: showCompletedTask ? "Completed" : "Ongoing"
                )
            )
            .animation(.smooth(duration: 0.1), value: ongoingTodos)
            .animation(.smooth(duration: 0.1), value: showCompletedTask)
            .animation(.smooth(duration: 0.1), value: searchQuery)
            .sheet(isPresented: $showCreateSheet) {
                NavigationStack {
                    CreateToDo()
                        .interactiveDismissDisabled()
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
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.smooth(duration: 0.5)) {
                            showCompletedTask.toggle()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(showCompletedTask ? .green : .gray)
                            .font(.system(size: 24))
                            .frame(width: 24)
                            .rotation3DEffect(
                                .degrees(showCompletedTask ? 360 : 0),
                                axis: (x: 1, y: 0, z: 0)
                            )
                    }
                }

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
            .overlay {
                if !searchQuery.isEmpty {
                    if showCompletedTask == false && searchOngoingTodos.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 32))
                                .foregroundStyle(BrandColors.Gray400)
                            Text(
                                "There's no task named '\(Text(searchQuery).bold())'"
                            )
                            .font(.system(size: 22))
                            .foregroundStyle(BrandColors.Gray400)
                            .multilineTextAlignment(.center)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .init(horizontal: .center, vertical: .center)
                        )
                        .frame(minHeight: 256)
                        .padding(40)
                        .transition(.opacity)
                    }
                    
                    if showCompletedTask == true && searchCompletedTodos.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 32))
                                .foregroundStyle(BrandColors.Gray400)
                            Text(
                                "There's no task named '\(Text(searchQuery).bold())'"
                            )
                            .font(.system(size: 22))
                            .foregroundStyle(BrandColors.Gray400)
                            .multilineTextAlignment(.center)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .init(horizontal: .center, vertical: .center)
                        )
                        .frame(minHeight: 256)
                        .padding(40)
                        .transition(.opacity)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                ZStack {
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                                .foregroundStyle(BrandColors.Gray500)
                            TextField("Search task or category here", text: $searchQuery)
                        }
                        .padding()
                        .padding(.horizontal, 2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                                .fill(BrandColors.Gray0)
                                .shadow(color: BrandColors.Gray200, radius: 16)
                        )
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 88)
                }
                .ignoresSafeArea()
                .background {
                    Rectangle()
                        .fill(.white)
                        .mask {
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black, location: 0.3),
                                    .init(color: .black, location: 1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .ignoresSafeArea()
                }
                .frame(height: 64)
            }
        }
    }

    private var searchOngoingTodos: [TodoItem] {
        guard !searchQuery.isEmpty else {
            return ongoingTodos
        }

        return ongoingTodos.filter { todo in
            // Match title OR any category name
            todo.title.localizedStandardContains(searchQuery)
                || todo.categories.contains {
                    $0.name.localizedStandardContains(searchQuery)
                }
        }
    }

    private var searchCompletedTodos: [TodoItem] {
        guard !searchQuery.isEmpty else {
            return completedTodos
        }

        return completedTodos.filter { todo in
            // Match title OR any category name
            todo.title.localizedStandardContains(searchQuery)
                || todo.categories.contains {
                    $0.name.localizedStandardContains(searchQuery)
                }
        }
    }

    // get navigation name
    private func navigationTitleName(todo: [TodoItem], taskName: String)
        -> String
    {
        if todo.isEmpty {
            return "No \(taskName) task"
        } else {
            if todo.count > 1 {
                return "\(todo.count) \(taskName) tasks"
            }
            return "\(todo.count) \(taskName) task"
        }
    }

    // with ViewBuilder, you can return different types of views
    @ViewBuilder
    private func completedTaskList() -> some View {
        if completedTodos.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(BrandColors.Gray400)
                Text("Completed tasks will show up here")
                    .font(.system(size: 17))
                    .foregroundStyle(BrandColors.Gray400)
                    .padding(8)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .init(horizontal: .center, vertical: .center)
            )
            .frame(minHeight: 256)
        }
        
        ForEach(searchCompletedTodos) { item in
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

                    Button {
                        withAnimation(.smooth) {
                            item.isCompleted.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .tint(.blue)
                    }
                }

        }
    }

    @ViewBuilder
    private func ongoingTaskList() -> some View {
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
            .frame(
                maxWidth: .infinity,
                alignment: .init(horizontal: .center, vertical: .center)
            )
            .frame(minHeight: 256)
            .transition(.opacity)
        }

        ForEach(searchOngoingTodos) { item in
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
                    withAnimation(.smooth) {
                        item.isCompleted.toggle()
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .tint(.green)
                }
            }
        }
    }

    @ViewBuilder
    private func showCompletedTaskButton() -> some View {
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TodoItem.self, Categories.self])
}
