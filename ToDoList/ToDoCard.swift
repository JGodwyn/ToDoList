//
//  ToDoCard.swift
//  ToDoList
//
//  Created by Gdwn16 on 04/12/2025.
//

import SwiftData
import SwiftUI

struct ToDoCard: View {

    let todoObj: TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if todoObj.isCritical {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.red)
                    Text("Important")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.red)
                }
                .padding(.horizontal, 8)
                .padding(.trailing, 4)
                .padding(.vertical, 8)
                .background(
                    .red.opacity(0.1),
                    in: RoundedRectangle(
                        cornerRadius: .infinity,
                        style: .continuous
                    )
                )
            }

            Text(todoObj.title)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.leading)
            Text(
                todoObj.timeStamp,
                format: Date.FormatStyle(date: .abbreviated)
            )
            .foregroundStyle(BrandColors.Gray500)
            
            // all categories
            if !todoObj.categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(todoObj.categories) { category in
                            HStack(spacing: 4) {
                                Text(category.name)
                                    .font(.system(size: 16))
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .circular
                                )
                                .frame(width: 12, height: 12)
                                .foregroundStyle(
                                    Color(hex: category.colorCode)
                                )
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Color(hex: category.colorCode).opacity(0.1),
                                in: RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                        }
                    }
                    .padding(.trailing, 24)
                }
                .overlay(alignment: .trailing) {
                    VStack {
                        
                    }
                    .frame(width: 40, height: 40)
                    .background(.white, in: Rectangle())
                    .blur(radius: 8, opaque: false)
                    .padding(.trailing, -24)
                }
            }

            if todoObj.isCompleted {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.green)
                    Text("Completed")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 8)
                .padding(.trailing, 4)
                .padding(.vertical, 8)
                .background(
                    .green.opacity(0.1),
                    in: RoundedRectangle(
                        cornerRadius: .infinity,
                        style: .continuous
                    )
                )
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ToDoCard(
        todoObj: TodoItem(
            title: "This is the long name of a card",
            timeStamp: .now,
            isCritical: true,
            isCompleted: true
        )
    )
}
