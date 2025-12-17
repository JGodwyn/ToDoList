//
//  CreateToDo.swift
//  ToDoList
//
//  Created by Gdwn16 on 03/12/2025.
//

import SwiftData
import SwiftUI

struct CreateToDo: View {

    @Environment(\.dismiss) var dismiss  // to close the sheet
    @Environment(\.modelContext) var context  // object you use to create, insert, delete, and save to your model
    // remember that you passed the model object via ModelContainer on the root file (ToDoListApp). this way, this object is available to any view that wants it
    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]
    @State private var item = TodoItem()
    @State private var selectedCategoryIDs: Set<PersistentIdentifier> = []  // IDs of all selected categories

    var body: some View {
        VStack(spacing: 12) {
            TextField("Name", text: $item.title)
                .padding()
                .padding(.horizontal, 4)
                .background(
                    BrandColors.Gray50,
                    in: RoundedRectangle(cornerRadius: 24)
                )
            DatePicker("Choose a date", selection: $item.timeStamp)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    BrandColors.Gray50,
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
            Toggle("Important", isOn: $item.isCritical)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    BrandColors.Gray50,
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
            if !categoriesQuery.isEmpty {
                VStack(alignment: .leading) {
                    Text("Where do these fall under?")
                        .foregroundStyle(BrandColors.Gray500)
                        .padding(.vertical)
                    ScrollView(showsIndicators: false) {
                        FlowLayout {
                            ForEach(categoriesQuery) { category in
                                Pills(
                                    name: category.name,
                                    colorCode: category.colorCode,
                                    isSelected: selectedCategoryIDs.contains(
                                        category.persistentModelID
                                    )
                                ) {
                                    toggleSelection(category)
                                }
                                //
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .frame(height: 200)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    BrandColors.Gray0,
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
            }

            MainButton(
                label: "Create",
                fillContainer: true,
                disabled: item.title.isEmpty
            ) {
                item.categories = categoriesQuery.filter {
                    selectedCategoryIDs.contains($0.persistentModelID)
                }
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

    // check whether the selected category exists in the set
    private func toggleSelection(_ category: Categories) {
        if selectedCategoryIDs.contains(category.persistentModelID) {
            selectedCategoryIDs.remove(category.persistentModelID)
        } else {
            selectedCategoryIDs.insert(category.persistentModelID)
        }
    }
}

#Preview {
    CreateToDo()
        .modelContainer(for: TodoItem.self)
}
