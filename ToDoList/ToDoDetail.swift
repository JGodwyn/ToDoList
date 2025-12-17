//
//  ToDoDetail.swift
//  ToDoList
//
//  Created by Gdwn16 on 04/12/2025.
//

import SwiftUI
import SwiftData

struct ToDoDetail: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    // @Bindable is interesting cos in this context, it works
    // the same way as @Binding. the thing is @Bindable is only
    // used on SwiftData models and Observable objects
    // @Bindable affects the object itself whereas
    // @Binding affects the parent's object
    @Bindable var todoObj : TodoItem
    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]
    @State private var todoTemp : ToDoTemp = .example
    @State private var selectedCategoryIDs: Set<PersistentIdentifier>
    
    // initialize the categories
    init(todoObj: TodoItem) {
        self.todoObj = todoObj
        _selectedCategoryIDs = State(initialValue: Set(todoObj.categories.map { $0.persistentModelID }))
        
        // a few things going on here
        // 1. why do we need an init() instead of something like this? @State private var selectedCategoryIDs: Set<PersistentIdentifier> = Set(todoObj(…
        // that's an error in Swift because item don't exist when you're creating the object
        // 2. why the '_'? this is to tell Swift that selectedCategoryIDs should point to the one outside (they should be the same object)
        // 3. What does State(initialValue:…) mean? well that's like saying @State private var… . just like in #1, item don't exist outside yet, you need to wrap it in an init to get the value. this is because of the dependency on item.
        
    }
    
    var body: some View {
        VStack {
            TextField("Name", text: $todoTemp.title)
                .padding()
                .padding(.horizontal, 4)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24))
            DatePicker("Date", selection: $todoTemp.timeStamp)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            Toggle("Important", isOn: $todoTemp.isCritical)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            Toggle("Done with this task?", isOn: $todoTemp.isCompleted)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            if !categoriesQuery.isEmpty {
                ScrollView(showsIndicators: false) {
                    FlowLayout {
                        ForEach(categoriesQuery) { category in
                            Pills(
                                name: category.name,
                                colorCode: category.colorCode,
                                isSelected: selectedCategoryIDs.contains(category.persistentModelID)
                            ) {
                                toggleSelection(category)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .frame(height: 200)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .overlay(alignment: .bottom) {
                    VStack {
                        
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(BrandColors.Gray0, in: Rectangle())
                    .padding(.bottom, 8)
                    .blur(radius: 16, opaque: false)
                }
            }
            
            MainButton(label: "Update", fillContainer: true, disabled: todoTemp.title.isEmpty) {
                withAnimation(.smooth(duration: 0.3)) {
                    todoObj.title = todoTemp.title
                    todoObj.timeStamp = todoTemp.timeStamp
                    todoObj.isCritical = todoTemp.isCritical
                    todoObj.isCompleted = todoTemp.isCompleted
                    todoObj.categories = categoriesQuery.filter {
                        selectedCategoryIDs.contains($0.persistentModelID)
                    }
                }
                dismiss()
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Your To-do")
        .animation(.easeOut, value: todoObj.isCompleted)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            todoTemp.title = todoObj.title
            todoTemp.timeStamp = todoObj.timeStamp
            todoTemp.isCritical = todoObj.isCritical
            todoTemp.isCompleted = todoObj.isCompleted
        }
    }
    
    private func toggleSelection(_ category: Categories) {
        if selectedCategoryIDs.contains(category.persistentModelID) {
            selectedCategoryIDs.remove(category.persistentModelID)
        } else {
            selectedCategoryIDs.insert(category.persistentModelID)
        }
    }
}

#Preview {
    ToDoDetail(todoObj: .init())
    ContentView()
        .modelContainer(for: [TodoItem.self, Categories.self])
}


// added this struct to prevent immediate update of the task when editing
// data will be stored in this struct until you press the button to update
struct ToDoTemp {
    var title : String
    var timeStamp : Date
    var isCritical : Bool
    var isCompleted : Bool
//    var mainCategories : [Categories]
    
    static var example : ToDoTemp {
        ToDoTemp(title: "", timeStamp: .init(), isCritical: false, isCompleted: false)
    }
}
