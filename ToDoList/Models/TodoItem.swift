//
//  TodoItem.swift
//  ToDoList
//
//  Created by Gdwn16 on 03/12/2025.
//

import Foundation
import SwiftData

// using SwiftData instead of our typical struct model
// items in swiftData tend to persist when you close the app
// when working with SwiftData, your models need to be represented as classes not structs
// you can add computed properties to your models also

@Model
final class TodoItem {
    var title: String
    var timeStamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    var categories : [Categories]
    
    var categoryCount : Int {
        self.categories.count
        // this is not necessary but helps to understand computed properties
        // this essentially works like @Transient properties as they are not stored in memory
    }
    
    @Attribute(.externalStorage) // store this data outside your main database, you only just reference it. much better memory control and performance
    var image: Data? // there's a data type

    init(
        title: String = "",
        timeStamp: Date = .now,
        isCritical: Bool = false,
        isCompleted: Bool = false,
        categories: [Categories] = []
    ) {
        self.title = title
        self.timeStamp = timeStamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
        self.categories = categories
    }
}

extension TodoItem {
    static var defaultTask: [TodoItem] {
        [
            TodoItem(title: "Eat your vegetables", isCritical: true, isCompleted: false, categories: Categories.defaultHealthUrgent),
            TodoItem(title: "Review your career goals", isCritical: false, isCompleted: false, categories: Categories.defaultCareerPending)
        ]
    }
}

enum SortableFields : String, CaseIterable, Identifiable {
    
    var id : Self { self }
    case title = "Title"
    case timeStamp = "Date"
    case isCritical = "Importance"
    case categoryCount = "Number of Categories"
    
    var name : String {
        switch self {
        case .title: return "Title"
        case .timeStamp: return "Date"
        case .isCritical: return "Importance"
        case .categoryCount: return "Number of Categories"
        }
    }
}

// this handles the sorting
extension [TodoItem] {
     func sortItems(using sortValue: SortableFields) -> [TodoItem] {
        switch sortValue {
        case .title:
            return sorted(by: { $0.title.lowercased() < $1.title.lowercased() })

        case .isCritical:
            return sorted(by: { $0.isCritical && !$1.isCritical })

        case .timeStamp:
            return sorted(by: { $0.timeStamp < $1.timeStamp })

        case .categoryCount:
            return sorted(by: { $0.categories.count > $1.categories.count })
        }
    }
}
