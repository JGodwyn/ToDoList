//
//  CreateCategory.swift
//  ToDoList
//
//  Created by Gdwn16 on 08/12/2025.
//

import SwiftUI
import SwiftData

struct CreateCategory: View {
    @Environment(\.modelContext) var categoryContext
    @FocusState private var inputNameFocused : Bool
    @State private var noNameError : Bool = false
    @State private var attempts : Int = 0
    @State private var CategoryItem = Categories()
    let tappedButton : () -> Void
    
    
    var body: some View {
        VStack(spacing: 8) {
            BrandImages.BrandLogo
                .resizable()
                .frame(width: 32, height: 32)
            Text("Name this category")
                .foregroundStyle(.gray)
                .bold()
            
            TextField(text: $CategoryItem.name) {
                Text(noNameError ? "Enter name first" : "Type here")
                    .foregroundStyle(noNameError ? .red.opacity(0.5) : BrandColors.Gray200)
            }
            .modifier(ShakeEffect(animatableData: CGFloat(attempts)))
            .font(.system(size: 24, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(.vertical, 32)
            .focused($inputNameFocused)
            
            VStack(spacing: 16) {
                MainButton(label: "Create Category", fillContainer: true) {
                    if CategoryItem.name.isEmpty {
                        noNameError = true
                        withAnimation (.easeOut) {
                            attempts += 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            noNameError = false
                        }
                    } else {
                        categoryContext.insert(CategoryItem)
                        tappedButton()
                    }
                }
                
                MainButton(label: "Cancel", lightBtn: true, fillContainer: true) {
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
}

#Preview {
    CreateCategory() {}
}


struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 12 // The maximum offset during the shake
    var shakesPerUnit: Int = 3 // Number of shakes per animation cycle
    var animatableData: CGFloat // The progress of the animation
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translationX = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translationX, y: 0))
    }
}
