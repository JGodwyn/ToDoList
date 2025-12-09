//
//  Buttons.swift
//  ToDoList
//
//  Created by Gdwn16 on 08/12/2025.
//

import Foundation
import SwiftUI


struct MainButton : View {
    
    let btnLabel : String
    let iconLeft : String
    let iconRight : String
    let lightBtn : Bool
    let btnColor : Color
    let height : CGFloat
    let fillContainer : Bool
    let btnDisabled : Bool
    let tappedButton : () -> Void
    
    // initialize with label, color, fillContainer, and function
    // default values are set for all of these except function
    init(label: String = "No label",
         lightBtn: Bool = false,
         btnColor: Color = BrandColors.BrandMain,
         iconLeft: String = "none",
         iconRight: String = "none",
         height: CGFloat = 48,
         fillContainer: Bool = false,
         disabled: Bool = false,
         action: @escaping () -> Void) {
        self.btnLabel = label
        self.lightBtn = lightBtn
        self.btnColor = btnColor
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        self.height = height
        self.fillContainer = fillContainer
        self.btnDisabled = disabled
        self.tappedButton = action
    }
    
    var body: some View {
        Button (action: tappedButton) {
            Text(btnLabel)
        }
        .disabled(btnDisabled)
        .opacity(btnDisabled ? 0.5 : 1)
        .buttonStyle(MainButtonStyle(lightBtn: lightBtn, color: btnDisabled ? .gray : btnColor, iconLeft: iconLeft, iconRight: iconRight, height: height, fillContainer: fillContainer))
        
    }
}


struct IconButton : View {
    
    let icon : String
    let lightBtn : Bool
    let btnColor : Color
    let height : CGFloat
    let tappedButton : () -> Void
    
    init(icon : String = "button.programmable",
         lightBtn : Bool = false,
         btnColor : Color = BrandColors.BrandMain,
         height : CGFloat = 40,
         action: @escaping () -> Void
    ) {
        self.icon = icon
        self.lightBtn = lightBtn
        self.btnColor = btnColor
        self.height = height
        self.tappedButton = action
    }
    
    var body: some View {
        Button(action: tappedButton) {
            Image(systemName: icon)
        }
        .buttonStyle(IconButtonStyle(icon: icon, lightBtn: lightBtn, color: btnColor, height: height))
    }
    
}


struct PlainButton: View {
    
    let btnLabel : String // label on button
    let tappedButton : () -> Void // when they tap the button
    
    var body: some View {
        Button (action: tappedButton) {
            Text(btnLabel)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct IconLabelButton : View {
    
    let btnLabel : String  // label on button
    let btnImage : String // image on button
    let tappedButton : () -> Void // when they tap the button
    
    // see what happens here
    // in the PlainButtonStyle declaration, I already have an HStack
    // Here, I added another one to place my icon in.
    var body: some View {
        Button (action: tappedButton) {
            HStack {
                Image(systemName: btnImage)
                Text(btnLabel)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}


#Preview {
    Group {
        PlainButton(btnLabel: .init("Plain button")){}
        IconLabelButton(btnLabel: .init("Icon button"), btnImage: .init("button.programmable")){}
        MainButton(){}
        MainButton(label: "Lightened button", lightBtn: true, iconLeft: "plus", iconRight: "minus"){}
        MainButton(iconRight: "plus", disabled: true){}
        MainButton(label: "Default button"){}
        MainButton(label: "Secondary button", btnColor: BrandColors.Gray100){}
        MainButton(label: "Red button", btnColor: .red){}
        MainButton(label: "Red button", btnColor: .red, disabled: true){}
        MainButton(label: "Green button", btnColor: .green, fillContainer: true){}
        MainButton(label: "Green button", btnColor: .green, height: 48, fillContainer: false){}
        IconButton(icon: "minus") {}
        IconButton(icon: "plus", lightBtn: true, btnColor: BrandColors.Gray50) {}
    }
    .padding(8)
}
