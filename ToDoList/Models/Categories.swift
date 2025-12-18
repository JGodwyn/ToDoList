//
//  Categories.swift
//  ToDoList
//
//  Created by Gdwn16 on 09/12/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Categories {
    var name: String
    var colorCode: String
    var colorName: String
    var created: Date
    @Relationship(inverse: \TodoItem.categories) var todos: [TodoItem] = [] // use this to see all the tasks in a category

    init(name: String = "", colorCode: String = "#925E78", colorName: String = "Dusty Lavender", created: Date = .now) {
        self.name = name
        self.colorCode = colorCode
        self.colorName = colorName
        self.created = created
        self.todos = []
    }
}

enum CategoryColors: CaseIterable {
    case DustyLavender,
        BubblegumPink,
        NeonPink,
        JungleGreen,
        CanaryYellow,
        BrightIndigo,
        Cream,
        IndigoBloom,
        NeonIce,
        FreshSky,
        DeepWalnut

    var colorDescription: String {
        switch self {
        case .DustyLavender:
            return "Dusty Lavender"
        case .BubblegumPink:
            return "Bubblegum Pink"
        case .NeonPink:
            return "Neon Pink"
        case .JungleGreen:
            return "Jungle Green"
        case .CanaryYellow:
            return "Canary Yellow"
        case .BrightIndigo:
            return "Bright Indigo"
        case .Cream:
            return "Cream"
        case .IndigoBloom:
            return "Indigo Bloom"
        case .NeonIce:
            return "Neon Ice"
        case .FreshSky:
            return "Fresh Sky"
        case .DeepWalnut:
            return "Deep Walnut"
        }
    }
    
    var colorCode: String {
        switch self {
        case .DustyLavender:
            return "#925E78"
        case .BubblegumPink:
            return "#F05365"
        case .NeonPink:
            return "#EE2677"
        case .JungleGreen:
            return "#00A676"
        case .CanaryYellow:
            return "#F4FF52"
        case .BrightIndigo:
            return "#1E2EDE"
        case .Cream:
            return "#EAF8BF"
        case .IndigoBloom:
            return "#6F2DBD"
        case .NeonIce:
            return "#4DFFF3"
        case .FreshSky:
            return "#00A6ED"
        case .DeepWalnut:
            return "#573D1C"
        }
    }
    
    
}

extension Color {
    init(hex: String) {
        let hex = String(hex.dropFirst()).replacingOccurrences(
            of: "#",
            with: ""
        )
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        let a = hex.count == 8 ? Double((rgb >> 24) & 0xFF) / 255.0 : 1.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }

    var hex: String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255)),
            lroundf(Float(a * 255))
        )
    }
}
