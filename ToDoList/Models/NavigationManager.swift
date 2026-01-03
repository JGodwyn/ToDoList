//
//  NavigationManager.swift
//  ToDoList
//
//  Created by Gdwn16 on 02/01/2026.
//

import Foundation
import SwiftUI

@Observable
final class NavigationManager {
    var navigator = NavigationPath()
    
    func push(to screen: FilterTypes) {
        self.navigator.append(screen)
    }
    
    func popToRoot() {
        navigator = NavigationPath() // this will take it to the root navigation (ContentView)
    }
}
