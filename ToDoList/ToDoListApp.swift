//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Gdwn16 on 02/12/2025.
//

import SwiftUI
import SwiftData

// skipped learning migrations until later

@main
struct ToDoListApp: App {
    
    @State private var navObj = NavigationManager()
    @AppStorage("FirstTimeUsingTheApp") private var isFirstTimeUsingTheApp: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(AppModelContainer.create(createDefaults: &isFirstTimeUsingTheApp))
            //                .modelContainer(for: [TodoItem.self, Categories.self])
        }
        .environment(navObj) // use this to navigate
    }
}
