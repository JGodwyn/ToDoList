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
    @State private var showCount : Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(categoryObj.name)")
                            .font(.system(size: 28, weight: .bold))
                        
                        HStack {
                            Text("\(categoryObj.todos.count) tasks")
                                .padding(.vertical, 8)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(BrandColors.Gray500)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "eye")
                                Text("\(showCount)")
                                    .padding(.vertical, 8)
                                    .font(.system(size: 22, weight: .semibold))
                            }
                            .foregroundStyle(BrandColors.Gray500)
                        }
                        
                    }
                    Spacer()
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(hex: categoryObj.colorCode))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
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
            .onAppear {
                categoryObj.categoryViewCount += 1
                showCount = categoryObj.categoryViewCount
                // had to pass this to a @State property cos
                // Swift don't update the values of transient properties...for now
            }
        }
    }
}

#Preview {
    CategorizedTask(categoryObj: .init(name: "New Category", created: .now))
}
