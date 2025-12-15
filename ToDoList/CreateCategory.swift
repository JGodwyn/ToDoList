//
//  CreateCategory.swift
//  ToDoList
//
//  Created by Gdwn16 on 08/12/2025.
//

import SwiftData
import SwiftUI

struct CreateCategory: View {
    @Environment(\.modelContext) var context
    @FocusState private var inputNameFocused: Bool
    @State private var noNameError: Bool = false
    @State private var attempts: Int = 0
    @State private var CategoryItem = Categories()
    @State private var CategoryColor: CategoryColors = .BrightIndigo
    @State private var showColorMenu: Bool = false
    let tappedButton: () -> Void

    var body: some View {
        ZStack {
            // use this to dismiss every open menu when they're tapped beyond bounds
            Color.white.opacity(0.0001)
                .ignoresSafeArea()
                .onTapGesture {
                    showColorMenu = false
                }

            VStack(spacing: 8) {
                TextField(text: $CategoryItem.name) {
                    Text(noNameError ? "Enter name first" : "Category name")
                        .foregroundStyle(
                            noNameError
                                ? .red.opacity(0.5) : BrandColors.Gray200
                        )
                }
                .modifier(ShakeEffect(animatableData: CGFloat(attempts)))
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.vertical, 32)
                .focused($inputNameFocused)

                // color picker
                HStack(spacing: 16) {
                    Button {
                        showColorMenu.toggle()
                    } label: {
                        HStack {
                            Text(CategoryColor.colorDescription)
                                .font(.system(size: 18, weight: .bold))
                            RoundedRectangle(cornerRadius: 16, style: .circular)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(
                                    Color(hex: CategoryColor.colorCode)
                                )
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Color(hex: CategoryColor.colorCode).opacity(0.1),
                            in: RoundedRectangle(
                                cornerRadius: 16,
                                style: .continuous
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 24)
                .zIndex(100)
                .overlay(alignment: .center) {
                    // Color menu
                    if showColorMenu {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(CategoryColors.allCases, id: \.self)
                                    { category in
                                        Button {
                                            showColorMenu = false
                                            CategoryColor = category
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
                        .frame(width: 280, height: 256)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 48))
                        .mask {
                            RoundedRectangle(cornerRadius: 48)
                        }
                        .padding(.bottom, 56)
//                        .transition(
//                            .move(edge: .bottom).combined(with: .blurReplace)
//                                .combined(with: .scale)
//                        )
                        .transition(.blurReplace.combined(with: .scale))
                        .shadow(color: .black.opacity(0.2), radius: 56, x: 0, y: 12)
                    }
                }

                // Buttons
                VStack(spacing: 16) {
                    MainButton(label: "Create Category", fillContainer: true) {
                        showColorMenu = false
                        if CategoryItem.name.isEmpty {
                            noNameError = true
                            withAnimation(.easeOut) {
                                attempts += 1
                            }
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1.5
                            ) {
                                noNameError = false
                            }
                        } else {
                            CategoryItem.colorCode = CategoryColor.colorCode
                            CategoryItem.colorName = CategoryColor.colorDescription
                            context.insert(CategoryItem)
                            tappedButton()
                        }
                    }

                    MainButton(
                        label: "Cancel",
                        lightBtn: true,
                        fillContainer: true
                    ) {
                        showColorMenu = false
                        tappedButton()
                    }
                }
            }
            .overlay(alignment: .top) {
                if noNameError {

                }
            }
            .animation(.spring, value: noNameError)
            .onAppear {
                withAnimation {
                    inputNameFocused = true
                }
            }
        }
        .animation(.spring(duration: 0.2), value: showColorMenu)
    }
}

#Preview {
    CreateCategory {}
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 12  // The maximum offset during the shake
    var shakesPerUnit: Int = 3  // Number of shakes per animation cycle
    var animatableData: CGFloat  // The progress of the animation

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translationX =
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(
            CGAffineTransform(translationX: translationX, y: 0)
        )
    }
}
