//
//  Categories.swift
//  ToDoList
//
//  Created by Gdwn16 on 09/12/2025.
//

import Foundation
import SwiftData


@Model
final class Categories {
    var name: String
    var created: Date

    init(name: String = "", created: Date = .now) {
        self.name = name
        self.created = created
    }
}
