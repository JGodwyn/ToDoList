//
//  ModelContainer.swift
//  ToDoList
//
//  Created by Gdwn16 on 27/12/2025.
//

import Foundation
import SwiftData

// prefill your app with default data the user should see

actor AppModelContainer {
    @MainActor
    static func create(createDefaults : inout Bool) -> ModelContainer {
        // inout allows you to modify whatever you pass into the function
        // even if it's a let parameter
        let schema = Schema([TodoItem.self, Categories.self])
        let configuration = ModelConfiguration()
        let container : ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            // handle the error here
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        if createDefaults {
            TodoItem.defaultTask.forEach{ container.mainContext.insert($0) } // insert the task
            createDefaults = false
        }
        return container
    }
}
