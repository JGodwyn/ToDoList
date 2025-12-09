//
//  CreateToDo.swift
//  ToDoList
//
//  Created by Gdwn16 on 03/12/2025.
//

import SwiftUI
import SwiftData

struct CreateToDo: View {
    
    @Environment(\.dismiss) var dismiss // to close the sheet
    @Environment(\.modelContext) var context // object you use to create, insert, delete, and save to your model
    // remember that you passed the model object via ModelContainer on the root file (ToDoListApp). this way, this object is available to any view that wants it
    @State private var item = TodoItem()
    
    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date", selection: $item.timeStamp)
            Toggle("Important", isOn: $item.isCritical)
            Button("Create") {
                withAnimation {
                    // use the context as a CRUD item
                    // in this case, we're inserting (creating) sth
                    context.insert(item)
                }
                dismiss()
            }
            .disabled(item.title.isEmpty ? true : false)
        }
        .navigationTitle("Create To Do")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateToDo()
        .modelContainer(for: TodoItem.self)
}
