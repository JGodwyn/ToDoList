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
    @AppStorage("TaskSortValue") private var sortTasksBy : SortableFields = .timeStamp
    
    @State private var showCreateSheet: Bool = false
    @State private var showCompletedTask: Bool = false
    @State private var searchQuery: String = ""
    @State private var navigationTitle: String = ""
    @State private var showSearchBar : Bool = false
    @State private var selectedTodo: TodoItem?
    @Query private var todoQuery: [TodoItem]
    
    @Query(
        filter: #Predicate<TodoItem> { $0.isCompleted == false }
    ) private var ongoingTodos: [TodoItem]
    
    // the opposite of above
    @Query(
        filter: #Predicate<TodoItem> { $0.isCompleted == true }
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
            .animation(.smooth(duration: 0.1), value: completedTodos)
            .animation(.smooth(duration: 0.1), value: showCompletedTask)
            .animation(.smooth(duration: 0.1), value: searchQuery)
            .animation(.smooth(duration: 0.1), value: sortTasksBy)
//            .animation(.smooth(duration: 0.1), value: searchOngoingTodos)
//            .animation(.smooth(duration: 0.1), value: searchCompletedTodos)
            .sheet(isPresented: $showCreateSheet) {
                NavigationStack {
                    CreateToDo() { showCompletedTask = false }
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
                        
                        Menu {
                            Picker("Sort by...", selection: $sortTasksBy) {
                                ForEach(SortableFields.allCases) { item in
                                    Text(item.name)
                                }
                            }
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort by...")
                            }
                        }
                        
                        Button {
                            // for filters
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "line.3.horizontal.decrease")
                                Text("Filter")
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
                if showCompletedTask == false {
                    // when you're on ongoing task
                    if !searchQuery.isEmpty || !searchOngoingTodos.isEmpty {
                        searchBar
                            .transition(.move(edge: .bottom).combined(with: .blurReplace))
                    }
                }
                
                if showCompletedTask == true {
                    // when you're on completed task
                    if !searchQuery.isEmpty || !searchCompletedTodos.isEmpty {
                        searchBar
                            .transition(.move(edge: .bottom).combined(with: .blurReplace))
                    }
                }
            }
            .overlay {
                // show the empty states
                if searchQuery.isEmpty {
                    if showCompletedTask == false && searchOngoingTodos.isEmpty {
                        emptyStateView(description: "You have no ongoing tasks", showButton: true)
                    }
                    
                    if showCompletedTask == true && searchCompletedTodos.isEmpty {
                        emptyStateView(description: "No completed tasks", image: "checkmark.circle.fill")
                    }
                }
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
    private func emptyStateView(description: String, image: String = "tray.full.fill", showButton: Bool = false) -> some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: image)
                .font(.system(size: 32))
                .foregroundStyle(BrandColors.Gray400)
            Text(description)
                .font(.system(size: 17))
                .foregroundStyle(BrandColors.Gray400)
            
            if showButton {
                MainButton(label: "Add a task", height: 32) {
                    showCreateSheet.toggle()
                }
                .padding(8)
            }
        }
    }
    
    @ViewBuilder
    private func completedTaskList() -> some View {
        ForEach(searchCompletedTodos.sortItems(using: sortTasksBy)) { item in
            ToDoCard(todoObj: item)
                .buttonStyle(PlainButtonStyle())
                .swipeActions {
                    Button(role: .destructive) {
                        withAnimation {
                            context.delete(item)
                        }
                        try? context.save() // add this to persistent storage immediately
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
        ForEach(searchOngoingTodos.sortItems(using: sortTasksBy)) { item in
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
                    try? context.save()  // add this to persistent storage immediately
                    
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
    
    private var searchBar : some View {
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

#Preview {
    ContentView()
        .modelContainer(for: [TodoItem.self, Categories.self])
}
