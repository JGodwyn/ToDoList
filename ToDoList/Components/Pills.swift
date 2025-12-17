//
//  Pills.swift
//  ToDoList
//
//  Created by Gdwn16 on 15/12/2025.
//

import SwiftUI

struct Pills: View {

    let name: String
    let colorCode: String
    let showColorSwatch: Bool
    let isSelected: Bool // toggle this outside the view
    let tappedPill : () -> Void

    // default values
    init(
        name: String = "Purple",
        colorCode: String = "#123AAF",
        showColorSwatch: Bool = true,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.colorCode = colorCode
        self.showColorSwatch = showColorSwatch
        self.isSelected = isSelected
        self.tappedPill = action
    }

    var body: some View {
        Button {
            tappedPill()
        } label: {
            HStack {
                Text(name)
                    .fontWeight(.medium)
                if showColorSwatch {
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .circular
                    )
                    .frame(width: 20, height: 20)
                    .foregroundStyle(
                        Color(hex: colorCode)
                    )
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(
                BrandColors.BrandSec,
                in: RoundedRectangle(cornerRadius: .infinity)
            )
            .animation(.smooth, value: isSelected)
            .padding(2)
            .overlay(alignment: .center) {
                if isSelected {
                    RoundedRectangle(cornerRadius: .infinity)
                        .strokeBorder(BrandColors.BrandMain, lineWidth: 4)
                        .transition(.blurReplace)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Pills(){}
}
