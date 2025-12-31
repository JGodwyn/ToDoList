//
//  Categories.swift
//  ToDoList
//
//  Created by Gdwn16 on 09/12/2025.
//

import Foundation
import SwiftData
import SwiftUI


// you can add computed properties to your models also
// computed properties are also not persisted in memory (they're transient)

@Model
final class Categories {
    var name: String
    var colorCode: String
    var colorName: String
    var created: Date
    @Relationship(inverse: \TodoItem.categories) var todos: [TodoItem] = [] // use this to see all the tasks in a category
    
    // just to illustrate that transient is not persisted in memory
    // you can liken it to a @State property
    @Transient
    var categoryViewCount : Int = 0

    init(name: String = "", colorCode: String = "#925E78", colorName: String = "Dusty Lavender", created: Date = .now, categoryViewCount: Int = 0) {
        self.name = name
        self.colorCode = colorCode
        self.colorName = colorName
        self.created = created
        self.todos = []
        self.categoryViewCount = 0
    }
}

extension Categories {
    // create default categories — Health, Urgent, Career, Pending
    // this would be loaded the first time the app is created
    static var defaultHealthUrgent : [Categories] {
        [
            .init(name: "Health", colorCode: "#00A676", colorName: "Jungle Green"),
            .init(name: "Urgent", colorCode: "#F05365", colorName: "Bubblegum Pink")
        ]
    }
    
    static var defaultCareerPending : [Categories] {
        [
            .init(name: "Career", colorCode: "#00A6ED", colorName: "Fresh Sky"),
            .init(name: "Pending", colorCode: "#F4FF52", colorName: "Canary Yellow")
        ]
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
