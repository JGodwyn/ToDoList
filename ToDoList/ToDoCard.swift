//
//  ToDoCard.swift
//  ToDoList
//
//  Created by Gdwn16 on 04/12/2025.
//

import SwiftUI
import SwiftData

struct ToDoCard: View {

    let todoObj : TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if todoObj.isCritical {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 24))
                    .foregroundStyle(.red)
            }
            Text(todoObj.title)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.leading)
            Text(
                todoObj.timeStamp,
                format: Date.FormatStyle(date: .long, time: .shortened)
            )
            .foregroundStyle(BrandColors.Gray500)
            
            if !todoObj.categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        ForEach(todoObj.categories) { category in
                            HStack(spacing: 4) {
                                Text(category.name)
                                    .font(.system(size: 16))
                                RoundedRectangle(cornerRadius: 16, style: .circular)
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
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(alignment: .topTrailing) {
            if todoObj.isCompleted {
                Button {
                    withAnimation {
                        todoObj.isCompleted.toggle()
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(todoObj.isCompleted ? .green : .gray.opacity(0.3))
                        .padding(8)
                }
            }
        }
    }
}

#Preview {
    ToDoCard(
        todoObj: TodoItem(title: "This is the long name of a card", timeStamp: .now, isCritical: true, isCompleted: true)
    )
}

