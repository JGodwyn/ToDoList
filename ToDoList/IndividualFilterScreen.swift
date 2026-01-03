//
//  IndividualFilters.swift
//  ToDoList
//
//  Created by Gdwn16 on 02/01/2026.
//

import SwiftUI
import SwiftData

struct IndividualFilterScreen: View {
    
    let filterType : FilterTypes
    @Query private var todos: [TodoItem]
    
    init(filterType: FilterTypes) {
        // initialize todos filtering using your filter type
        self.filterType = filterType
        _todos = Query(filter: filterType.filter())
    }
    
    var body: some View {
        List {
            ForEach(todos) { todo in
                ToDoCard(todoObj: todo)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle(filterType.title)
        .overlay {
            if todos.isEmpty {
                if filterType == .ImageAdded {
                    emptyStateView(description: "Tasks you added image to will show up here", image: filterType.icon)
                } else {
                    emptyStateView(description: "Your \(filterType.title.lowercased()) tasks will show up here", image: filterType.icon)
                }
            }
        }
    }
}

@ViewBuilder
private func emptyStateView(description: String, image: String = "tray.full.fill", showButton: Bool = false) -> some View {
    VStack(alignment: .center, spacing: 20) {
        Image(systemName: image)
            .font(.system(size: 32))
            .foregroundStyle(BrandColors.Gray400)
        Text(description)
            .multilineTextAlignment(.center)
            .font(.system(size: 17))
            .foregroundStyle(BrandColors.Gray400)
            .frame(width: 200)
    }
}

#Preview {
//    IndividualFilterScreen(filterType: .Ongoing)
    ContentView()
        .modelContainer(for: [TodoItem.self, Categories.self])
        .environment(NavigationManager())
}
