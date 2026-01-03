//
//  FilterCriteriaView.swift
//  ToDoList
//
//  Created by Gdwn16 on 31/12/2025.
//

import SwiftData
import SwiftUI

struct FilterCriteria: View {

    @Query private var todoQuery: [TodoItem]
    @Environment(NavigationManager.self) private var navManager

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading) {
                    filterBoxes(
                        name: "Today",
                        icon: "calendar",
                        iconColor: .white,
                        iconBg: BrandColors.BrandMain,
                        screenType: .Today
                    )
                    filterBoxes(
                        name: "Upcoming",
                        icon: "calendar.badge.clock",
                        iconColor: .white,
                        iconBg: .teal,
                        screenType: .Upcoming
                    )
                    filterBoxes(
                        name: "Overdue",
                        icon: "calendar.badge.exclamationmark",
                        iconColor: .white,
                        iconBg: .red,
                        screenType: .Overdue
                    )
                    filterBoxes(
                        name: "Important",
                        icon: "exclamationmark.3",
                        iconColor: .white,
                        iconBg: .pink,
                        screenType: .Important
                    )
                    filterBoxes(
                        name: "Ongoing",
                        icon: "clock.badge",
                        iconColor: .black,
                        iconBg: .yellow.opacity(0.5),
                        screenType: .Ongoing
                    )
                    filterBoxes(
                        name: "Completed",
                        icon: "checkmark",
                        iconColor: .white,
                        iconBg: .green,
                        screenType: .Completed
                    )
                    filterBoxes(
                        name: "Image added",
                        icon: "photo",
                        iconColor: .white,
                        iconBg: .gray,
                        screenType: .ImageAdded
                    )
                }
                .padding()
            }
            .background(BrandColors.Gray50)
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // do nothing for now
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(BrandColors.Gray500)
                    }
                }
            }
    }

    @ViewBuilder
    private func filterBoxes(
        name: String = "Label",
        icon: String = "eye",
        iconColor : Color = .black,
        iconBg : Color = BrandColors.Gray50,
        screenType: FilterTypes
    ) -> some View {
        Button {
            navManager.push(to: screenType)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
                    .padding(12)
                    .background(iconBg)
                    .clipShape(.circle)
                Text(name)
                    .font(.system(size: 20, weight: .semibold))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 120, alignment: .topLeading)
            .background(
                BrandColors.Gray0,
                in: RoundedRectangle(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterCriteria()
        .environment(NavigationManager())
}
