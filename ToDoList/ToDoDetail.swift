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
            
            MainButton(label: "Update", fillContainer: true, disabled: todoTemp.title.isEmpty) {
                withAnimation {
                    todoObj.title = todoTemp.title
                    todoObj.timeStamp = todoTemp.timeStamp
                    todoObj.isCritical = todoTemp.isCritical
                    todoObj.isCompleted = todoTemp.isCompleted
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
