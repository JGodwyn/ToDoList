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

@Model
final class TodoItem {
    var title: String
    var timeStamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    var categories : [Categories]

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
