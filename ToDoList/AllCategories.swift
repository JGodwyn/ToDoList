//
//  AllCategories.swift
//  ToDoList
//
//  Created by Gdwn16 on 09/12/2025.
//

import SwiftData
import SwiftUI

struct AllCategories: View {

    @Environment(\.modelContext) var context
    @Query(sort: \Categories.created, order: .reverse) private
        var categoriesQuery: [Categories]
    @State private var presentCreateSheet: Bool = false
    @State private var addingCategory: Bool = false
    @State private var selectedCategory: Categories?
    @State private var categorizedTaskToNavigate: Categories = .init()
    @State private var navigateToCategorizedTask: Bool = false

    var body: some View {
        List {
            ForEach(categoriesQuery) { item in
                Button {
                    selectedCategory = item
                    categorizedTaskToNavigate = item
                } label: {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.system(size: 22))

                            HStack {
                                Text(
                                    item.created,
                                    format: Date.FormatStyle(
                                        date: .abbreviated
                                    )
                                )
                                .foregroundStyle(BrandColors.Gray600)

                                Text(
                                    "\(item.todos.count) task\(item.todos.count > 1 ? "s" : "")"
                                )
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    BrandColors.Gray50,
                                    in: RoundedRectangle(
                                        cornerRadius: 16,
                                        style: .continuous
                                    )
                                )
                            }

                        }
                        Spacer()
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color(hex: item.colorCode))
                    }
                    .background(BrandColors.Gray0)
                }
                .buttonStyle(.plain)
                .swipeActions {
                    Button(role: .destructive) {
                        context.delete(item)
                        try? context.save()
                    } label: {
                        Image(systemName: "trash")
                    }

                    Button {
                        selectedCategory = item
                    } label: {
                        Image(systemName: "pencil")
                            .tint(BrandColors.BrandMain.opacity(0.5))
                    }
                }
            }

        }
        .navigationDestination(isPresented: $navigateToCategorizedTask) {
            CategorizedTask(categoryObj: categorizedTaskToNavigate)
        }
    .navigationTitle("\(categoriesQuery.count) Categories")
        .sheet(
            item: $selectedCategory,
            onDismiss: {
                selectedCategory = nil
            },
            content: { item in
                NavigationStack {
                    CategoryDetail(categoryObj: item) {
                        navigateToCategorizedTask = true
                    }
                    .interactiveDismissDisabled()
                    .presentationDetents([.height(400)])
                }
            }
        )
        .toolbar(addingCategory ? .hidden : .visible)  // show and hide toolbar
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addingCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .transition(.opacity)
        .overlay {
            if categoriesQuery.isEmpty {
                if !addingCategory {
                    VStack(spacing: 16) {
                        Image(systemName: "tray.full.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(BrandColors.Gray400)
                        Text("No categories to show here")
                            .font(.system(size: 20))
                            .foregroundStyle(BrandColors.Gray400)
                        MainButton(label: "Add category") {
                            addingCategory = true
                        }
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .navigationTitle("Categories")
                    .transition(.opacity)
                }
            }
        }

        .overlay {
            if addingCategory {
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()

                    CreateCategory {
                        addingCategory = false
                    }
                    .padding(.horizontal, 32)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: addingCategory)
    }
}

#Preview {
    AllCategories()
        .modelContainer(for: Categories.self)
}
