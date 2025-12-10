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
//    @Query private var categoriesQuery: [Categories]
    @Query(sort: \Categories.created) private var categoriesQuery: [Categories]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categoriesQuery) { item in
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.system(size: 22))
                            Text(
                                item.created,
                                format: Date.FormatStyle(date: .long, time: .shortened)
                            )
                            .foregroundStyle(BrandColors.Gray600)
                        }
                        Spacer()
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color(hex: item.color))
                    }
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
            .transition(.opacity)
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
        .toolbar(addingCategory ? .hidden : .visible)
    }
}

#Preview {
    AllCategories()
        .modelContainer(for: Categories.self)
}
