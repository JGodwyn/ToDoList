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
    @State private var todoTemp : ToDoTemp = .example
    
    var body: some View {
        List {
            TextField("Name", text: $todoTemp.title)
            DatePicker("Choose a date", selection: $todoTemp.timeStamp)
            Toggle("Important", isOn: $todoTemp.isCritical)
            Toggle("Done with this task?", isOn: $todoTemp.isCompleted)
            Button("Update") {
                withAnimation {
                    todoObj.title = todoTemp.title
                    todoObj.timeStamp = todoTemp.timeStamp
                    todoObj.isCritical = todoTemp.isCritical
                    todoObj.isCompleted = todoTemp.isCompleted
                }
                dismiss()
            }
        }
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
}

#Preview {
    ToDoDetail(todoObj: .init())
}


// added this struct to prevent immediate update of the task when editing
// data will be stored in this struct until you press the button to update
struct ToDoTemp {
    var title : String
    var timeStamp : Date
    var isCritical : Bool
    var isCompleted : Bool
    
    static var example : ToDoTemp {
        ToDoTemp(title: "", timeStamp: .init(), isCritical: false, isCompleted: false)
    }
}
