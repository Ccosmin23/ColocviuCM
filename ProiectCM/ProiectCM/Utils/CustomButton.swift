//
//  CustomButton.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 13.10.2021.
//

import SwiftUI

struct CustomButton: View {
    var width: CGFloat
    var height: CGFloat
    var text: String
    var icon: Image?
    var textColor: Color
    var background: Color
    var strokeColor: Color?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Text(self.text)
                        .foregroundColor(self.textColor)
                        .font(Font.Primary.bold.with(size: 16))
                        .frame(height: 56)
                    icon ?? nil
                }
                Spacer()
            }
            .frame(width: self.width, height: self.height)
            .background(self.background)
            .cornerRadius(16)
        }
        .modifier(RectangleStroke(strokeColor: self.strokeColor ?? self.background))
    }
}

/// this extension is used
extension CustomButton {
    static let _NFC = CustomButton(width: 96,
                                   height: 56,
                                   text: ScooterSheet.page.textButtons[0],
                                   textColor: Color.cerise,
                                   background: Color.white,
                                   strokeColor: Color.cerise)
    
    static let _QR = CustomButton(width: 96,
                                  height: 56,
                                  text: ScooterSheet.page.textButtons[1],
                                  textColor: Color.cerise,
                                  background: Color.white,
                                  strokeColor: Color.cerise)
    
    static let _123 = CustomButton(width: 96,
                                   height: 56,
                                   text: ScooterSheet.page.textButtons[2],
                                   textColor: Color.cerise,
                                   background: Color.white,
                                   strokeColor: Color.cerise)
    
    static let endRide = CustomButton(width: 153,
                                      height: 56,
                                      text: "End ride",
                                      textColor: Color.white,
                                      background: Color.cerise,
                                      strokeColor: Color.white)
    
    static let lock = CustomButton(width: 153,
                                   height: 56,
                                   text: "Lock",
                                   textColor: Color.cerise,
                                   background: Color.white,
                                   strokeColor: Color.cerise)
    
    static let unlock = CustomButton(width: 153,
                                     height: 56,
                                     text: "Unlock",
                                     textColor: Color.cerise,
                                     background: Color.white,
                                     strokeColor: Color.cerise)
    
    static let seeAll = CustomButton(width: 111,
                                     height: 48,
                                     text: "See all",
                                     icon: Image("forwardButtonWhite"),
                                     textColor: Color.white,
                                     background: Color.cerise,
                                     strokeColor: Color.cerise)
}

struct RectangleStroke: ViewModifier {
    var strokeColor: Color?
    
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(self.strokeColor ?? Color.white.opacity(0), lineWidth: 1))
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(width: 96,
                     height: 56,
                     text: "NFC",
                     icon: Image("forwardButtonWhite"),
                     textColor: Color.white,
                     background: Color.cerise,
                     strokeColor: Color.cerise)
    }
}
