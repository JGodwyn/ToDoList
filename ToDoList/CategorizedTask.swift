//
//  CategorizedTask.swift
//  ToDoList
//
//  Created by Gdwn16 on 17/12/2025.
//

import SwiftUI
import SwiftData

struct CategorizedTask: View {
    
    let categoryObj: Categories
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(categoryObj.name)")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(hex: categoryObj.colorCode))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text("\(categoryObj.todos.count) tasks")
                    .padding(.vertical, 8)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(BrandColors.Gray500)
                
                ScrollView(showsIndicators: false) {
                    ForEach(categoryObj.todos) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(size: 18, weight: .bold))
                                .multilineTextAlignment(.leading)
                            Text(
                                item.timeStamp,
                                format: Date.FormatStyle(date: .abbreviated)
                            )
                            .foregroundStyle(BrandColors.Gray500)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    CategorizedTask(categoryObj: .init(name: "New Category", created: .now))
}
