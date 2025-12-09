//
//  ButtonStyles.swift
//  ToDoList
//
//  Created by Gdwn16 on 08/12/2025.
//

import Foundation
import SwiftUI

struct MainButtonStyle : ButtonStyle {
    
    var lightBtn : Bool
    var color : Color
    var iconLeft : String
    var iconRight : String
    var height : CGFloat
    var fillContainer : Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if iconLeft != "none" {
                Image(systemName: iconLeft)
            }
            
            configuration.label
                .bold()
            
            if iconRight != "none" {
                Image(systemName: iconRight)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(height: height)
        .frame(maxWidth: fillContainer ? .infinity : .none)
        .foregroundStyle(lightBtn ? .blurple600 : .gray0)
        .background(lightBtn ? BrandColors.Gray50 : color)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(configuration.isPressed ? 0.7 : 1) // have the click effect
        .scaleEffect(configuration.isPressed ? 0.5 : 1) // slightly scale down
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed) // animate it
    }
}


struct IconButtonStyle : ButtonStyle {
    
    var icon : String
    var lightBtn : Bool
    var color : Color
    var height : CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if lightBtn {
                Image(systemName: icon)
                    .foregroundStyle(BrandColors.BrandMain)
            } else {
                Image(systemName: icon)
                    .foregroundStyle(BrandColors.Gray0)
            }
        }
        .frame(width: height, height: height)
        .background(color)
        .clipShape(Circle())
        .opacity(configuration.isPressed ? 0.7 : 1) // have the click effect
        .scaleEffect(configuration.isPressed ? 0.5 : 1) // slightly scale down
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed) // animate it
    }
}
