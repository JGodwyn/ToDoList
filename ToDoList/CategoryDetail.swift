//
//  CategoryDetail.swift
//  ToDoList
//
//  Created by Gdwn16 on 11/12/2025.
//

import SwiftUI

struct CategoryDetail: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var categoryObj: Categories
    @State private var showColorMenu: Bool = false
    @State private var tempCategory: tempCategory = .example
    @FocusState private var inputNameFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // use this to dismiss every open menu when they're tapped beyond bounds
                Color.white.opacity(0.0001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showColorMenu = false
                    }
                VStack(spacing: 24) {
                    VStack {
                        TextField("Category name", text: $tempCategory.name)
                            .focused($inputNameFocused)
                            .padding()
                            .padding(.horizontal, 4)
                            .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24))
                        HStack(spacing: 16) {
                            Button {
                                showColorMenu.toggle()
                                inputNameFocused = false
                            } label: {
                                HStack {
                                    Text("Color")
                                        .font(.system(size: 18))
                                    Spacer()
                                    HStack {
                                        Text(tempCategory.colorName)
                                            .font(.system(size: 18, weight: .bold))
                                        RoundedRectangle(
                                            cornerRadius: 16,
                                            style: .circular
                                        )
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(
                                            Color(hex: tempCategory.colorCode)
                                        )
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Color(hex: tempCategory.colorCode).opacity(0.1),
                                        in: RoundedRectangle(
                                            cornerRadius: 16,
                                            style: .continuous
                                        )
                                    )
                                }
                                .padding(.leading, 16)
                                .padding(.trailing, 8)
                                .padding(.vertical, 12)
                                .background(BrandColors.Gray50, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 16)
                    
                    MainButton(label: "Save changes", fillContainer: true, disabled: tempCategory.name.isEmpty) {
                        showColorMenu = false
                        categoryObj.name = tempCategory.name
                        categoryObj.colorCode = tempCategory.colorCode
                        categoryObj.colorName = tempCategory.colorName
                        dismiss()
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxHeight: .infinity, alignment: .top)
                .overlay(alignment: .topTrailing) {
                    // Color menu
                    if showColorMenu {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(CategoryColors.allCases, id: \.self) {
                                        category in
                                        Button {
                                            showColorMenu = false
                                            tempCategory.colorName = category.colorDescription
                                            tempCategory.colorCode = category.colorCode
                                        } label: {
                                            HStack {
                                                RoundedRectangle(
                                                    cornerRadius: 16,
                                                    style: .circular
                                                )
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(
                                                    Color(
                                                        hex: category.colorCode
                                                    )
                                                )
                                                Text(category.colorDescription)
                                                    .tag(category)
                                            }
                                            .frame(height: 48)
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 48))
                        .frame(width: 280, height: 256)
                        .transition(
                            .move(edge: .trailing).combined(with: .blurReplace)
                            .combined(with: .scale)
                        )
                        .mask {
                            RoundedRectangle(cornerRadius: 48)
                        }
                        .padding(.trailing, 32)
                        .padding(.top, -8)
                        .shadow(color: .black.opacity(0.2), radius: 56, x: 0, y: 12)
                    }
                }
                .navigationTitle("Edit category")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .animation(.spring(duration: 0.2), value: showColorMenu)
            .animation(.easeOut(duration: 0.1), value: tempCategory.name)
            .onChange(of: inputNameFocused) {
                if inputNameFocused == true {
                    showColorMenu = false
                }
            }
        }
        .onTapGesture {
            // this might cause issues, review it
            showColorMenu = false
        }
        .onAppear {
            tempCategory.name = categoryObj.name
            tempCategory.colorName = categoryObj.colorName
            tempCategory.colorCode = categoryObj.colorCode
        }
    }
}

#Preview {
    CategoryDetail(categoryObj: .init())
}


struct tempCategory {
    var name : String
    var colorName : String
    var colorCode : String
    
    static var example: tempCategory {
        tempCategory(name: "Example", colorName: "Black", colorCode: "#000000")
    }
}
