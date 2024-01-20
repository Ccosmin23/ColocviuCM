//
//  TextFieldView.swift
//  Move
//
//  Created by Cosmin Cosan on 30.08.2021.
//
import SwiftUI


/// TextFieldView struct is used just for Authentication and Login View textFields
struct TextFieldView: View {
    @Binding var credentialName: String
    @State var scrollTarget: Int?
    var enableSliding = false
    var title = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.Primary.regular.with(size: 12))
                .foregroundColor(Color.heliotropeGray)
                .isHidden(credentialName.isEmpty ? true : false)
            ZStack(alignment: .leading) {
                if credentialName.isEmpty {
                    Text(title)
                        .font(Font.Primary.medium.with(size: 16))
                        .foregroundColor(Color.heliotropeGray)
                }
                TextField("", text: $credentialName, onEditingChanged: { (isBegin) in
                    if isBegin {
                        scrollTarget = 1
                    }
                })
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .foregroundColor(.white)
                .frame(minHeight: 30)
            }
            HorizontalLine(color: Color.heliotropeGray)
        }
    }
}

/// CustomTextField struct is used for Account and History view textFields
struct CustomTextField: View {
    @State var prefilledText: String
    @Binding var credentialName: String
    @State var scrollTarget: Int?
    var enableSliding = false
    var title = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.Primary.regular.with(size: 12))
                .foregroundColor(Color.heliotropeGray)
                .isHidden(credentialName.isEmpty ? true : false)
            ZStack(alignment: .leading) {
                if credentialName.isEmpty {
                    Text(title)
                        .font(Font.Primary.medium.with(size: 16))
                        .foregroundColor(Color.heliotropeGray)
                }
                TextField(prefilledText, text: $credentialName, onEditingChanged: { (isBegin) in
                    if isBegin {
                        scrollTarget = 1
                    }
                })
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .foregroundColor(Color.russianViolet)
                .frame(minHeight: 30)
            }
            HorizontalLine(color: Color.heliotropeGray)
        }
    }
}


extension View {
    func underlineTextField() -> some View {
        self
            .lineSpacing(0)
            .padding(.vertical, 10)
            .overlay(Rectangle()
                        .frame(height: 2)
                        .padding(.top, 20)
            )
            .foregroundColor(Color.heliotropeGray)
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 1.0
    
    init(color: Color, height: CGFloat = 2.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}

struct HorizontalLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        return path
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
