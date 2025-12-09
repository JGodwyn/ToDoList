//
//  AllCategories.swift
//  ToDoList
//
//  Created by Gdwn16 on 09/12/2025.
//

import SwiftUI
import SwiftData

struct AllCategories: View {
    
    @State private var presentCreateSheet : Bool = false
    @State private var addingCategory : Bool = false
    @Query private var categoriesQuery: [Categories]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categoriesQuery) { item in
                    Text(item.name)
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addingCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
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
                    
                    CreateCategory() {
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
