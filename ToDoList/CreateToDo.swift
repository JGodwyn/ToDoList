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
        VStack(spacing: 12) {
            TextField("Name", text: $item.title)
                .padding()
                .padding(.horizontal, 4)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24))
            DatePicker("Choose a date", selection: $item.timeStamp)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            Toggle("Important", isOn: $item.isCritical)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            MainButton(label: "Create", fillContainer: true, disabled: item.title.isEmpty) {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
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
