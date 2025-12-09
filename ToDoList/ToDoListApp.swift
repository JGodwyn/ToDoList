//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Gdwn16 on 02/12/2025.
//

import SwiftUI
import SwiftData

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TodoItem.self, Categories.self])
        }
    }
}
